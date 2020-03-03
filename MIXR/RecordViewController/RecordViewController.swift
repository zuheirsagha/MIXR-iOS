//
//  ViewController.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-06-29.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit
import AVKit

class RecordViewController: UIViewController, RecordingDelegate {
    typealias CompletionHandler = (_ success:Bool, _ data : Data?) -> Void
    @IBOutlet weak var recordView: RecordView!
    var spinner : UIView?
    
    var songNames = ["Happy", "Happy LPF 800", "Mena Solo", "Mena Solo LPF"]
    var songLengths = ["4:30", "4:30", "1:35", "1:35"]
    var selectedSong = "Happy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = UIImage.init(named: "MIXRLogo")
        self.navigationItem.titleView = UIImageView.init(image: image)
    }
    
    func startedRecording() {
        print("started recording")
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func hitRecordButton() {
        showSpinner(true)
    }
    
    func showSpinner(_ bool: Bool) {
        if bool {
            if spinner == nil {
                spinner = UIView.init(frame: view.bounds)
                spinner?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
                let ai = UIActivityIndicatorView.init(style: .whiteLarge)
                ai.startAnimating()
                ai.center = spinner!.center
                
                DispatchQueue.main.async {
                    self.spinner?.addSubview(ai)
                    self.view.addSubview(self.spinner!)
                }
            }
        }
        else {
            DispatchQueue.main.async {
                self.spinner?.removeFromSuperview()
                self.spinner = nil
            }
        }
    }
    
    func MIXRDisconnected() {
        showSpinner(false)
        let noSongAlertController = UIAlertController(title: "Disconnected", message: "The MIXR device was disconnected, please reconnect and try recording again", preferredStyle: .alert)
        noSongAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        DispatchQueue.main.async {
            self.present(noSongAlertController, animated: true)
        }
    }
    
    func hitStopButton() {
        showSpinner(true)
    }
    
    func finishedRecording() {
        print("finished recording")
        if recordView.timerCtr > 0 {
            let alertController = UIAlertController(title: "Name your song", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.autocapitalizationType = .sentences
                textField.autocorrectionType = .no
            }
            alertController.addAction(UIAlertAction(title: "Delete Song", style: .destructive, handler: { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                guard let text = alertController.textFields?.first?.text else { return }
                self.selectedSong = text
                if text.count == 0 {
                    alertController.message = "Please enter a name with at least one character"
                    self.present(alertController, animated: true, completion: {})
                }
                else {
                    // save file to documents directory from bundle
                    let fileManager = FileManager.default
                    do {
                        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                        
                        let fileURL = documentDirectory.appendingPathComponent(text).appendingPathExtension("wav")
                        // TODO: get the actual file
//                        let asset = AVAsset(url: Bundle.main.url(forResource: "Happy", withExtension: "wav")!)
//                        let data = try Data(contentsOf: Bundle.main.url(forResource: "Happy", withExtension: "wav")!)
                        
                        self.getSong { (success, data) in
                            self.showSpinner(false)
                            if success {
                                do {
                                    if !fileManager.fileExists(atPath: fileURL.path) {
                                        try data!.write(to: fileURL)
                                        self.performSegue(withIdentifier: "RecordToPlayBackSegue", sender: self)
                                    }
                                    else {
                                        print("\(text) already exists at \(fileURL)")
                                        alertController.message = "File name already exists, please rename the song."
                                        self.present(alertController, animated: true, completion: {})
                                    }
                                }
                                catch {
                                    print(error)
                                }
                            }
                            else {
                                self.MIXRDisconnected()
                            }
                        }
//                        let length = self.timeFormatted(totalSeconds: Int((asset.duration.value)/Int64(asset.duration.timescale)))
//                        print("\(text) - \(length)")
//                        print(asset.metadata)
                    } catch {
                        print(error)
                    }
                }
            }))
            self.present(alertController, animated: true) { }
        }
    }
    
    func getSong(completionHandler: @escaping CompletionHandler) {
        spinner = UIView.init(frame: view.bounds)
        spinner?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinner!.center
        
        DispatchQueue.main.async {
            self.spinner?.addSubview(ai)
            self.view.addSubview(self.spinner!)
        }
        
        guard let url = URL(string: "http://192.168.4.1:8089/process") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = TimeInterval(exactly: 5)!

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionHandler(false, nil)
                return
            }
            completionHandler(true, data)
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PlayBackViewController {
            destinationVC.selectedSong = selectedSong
        }
    }
    
    func timeFormatted(totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return "\(minutes):\(seconds)"
    }
}

