//
//  HomeScreenViewController.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-07-21.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

class HomeScreenViewController : UIViewController {
    typealias CompletionHandler = (_ success:Bool) -> Void

    var spinner : UIView?
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var disconnectedText: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var newTrackButton: UIButton!
    @IBOutlet weak var newTrackImage: UIImageView!
    @IBOutlet weak var newTrackLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let logo = UIImage(named: "MIXRLogo")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
    
    @IBAction func onNewSongPressed(_ sender: Any) {
        print("New Track")
        ping { (success) in
            self.hideRetry(bool: success)
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "NewTrackSegue", sender: self)
                }
            }
        }
    }
    
    @IBAction func onListenPressed(_ sender: UIButton) {
        print("Listen")
        performSegue(withIdentifier: "ListenToTrackSegue", sender: self)
    }
    
    @IBAction func onRetryPressed(_ sender: Any) {
        ping { (success) in
            self.hideRetry(bool: success)
        }
    }
    
    func ping(completionHandler: @escaping CompletionHandler) {
        spinner = UIView.init(frame: view.bounds)
        spinner?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinner!.center
        
        DispatchQueue.main.async {
            self.spinner?.addSubview(ai)
            self.view.addSubview(self.spinner!)
        }
        
        guard let url = URL(string: "http://192.168.4.1:8089/ping") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = TimeInterval(exactly: 5)!

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        }.resume()
    }
    
    func hideRetry(bool : Bool) {
        DispatchQueue.main.async {
            self.disconnectedText.isHidden = bool
            self.retryButton.isHidden = bool
            self.newTrackButton.isEnabled = bool
            self.newTrackLabel.textColor = bool ? .black : .lightGray
            if #available(iOS 13.0, *) {
                self.newTrackImage.image = self.newTrackImage.image?.withTintColor(bool ? .black : .lightGray)
            }
            self.spinner?.removeFromSuperview()
            self.spinner = nil
        }
    }
}
