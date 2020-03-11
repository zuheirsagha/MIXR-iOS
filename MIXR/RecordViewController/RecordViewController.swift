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
    
    func hitRecordButton() {
        showSpinner(true)
    }
    
    func startingCountDown() {
        showSpinner(false)
    }
    
    func startedRecording() {
        self.navigationItem.setHidesBackButton(true, animated: false)
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
                
                self.getSong(completionHandler: { (success, data) in
                    self.showSpinner(false)
                    if success {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    else {
                        alertController.message = "There was an error connecting to MIXR, please reconnect and try again."
                        self.present(alertController, animated: true, completion: {})
                    }
                }, shouldProcess: false)
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
                        
                        self.getSong(completionHandler: { (success, data) in
                            self.showSpinner(false)
                            if success {
                                do {
                                    if !fileManager.fileExists(atPath: fileURL.path) {
                                        try data!.write(to: fileURL)
                                        DispatchQueue.main.async {
                                            self.performSegue(withIdentifier: "RecordToPlayBackSegue", sender: self)
                                        }
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
                        }, shouldProcess: true)
                        
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
    
    func getSong(completionHandler: @escaping CompletionHandler, shouldProcess : Bool) {
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
        request.setValue("setinstruments", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Bool] = [
            "shouldProcess": shouldProcess
        ]
        request.httpBody = parameters.percentEncoded()
        request.timeoutInterval = TimeInterval(exactly: 1000000000)!

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse, error == nil else {
                    print("error", error ?? "Unknown error")
                    completionHandler(false, Data())
                    return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                completionHandler(false, data)
                return
            }
            
            
            print(String(data: data, encoding: .utf8))
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

