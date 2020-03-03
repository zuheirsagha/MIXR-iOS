//
//  InputSelectionViewController.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2020-02-27.
//  Copyright © 2020 MIXR. All rights reserved.
//

import UIKit

class InputSelectionViewController : UIViewController {
    typealias CompletionHandler = (_ success:Bool) -> Void

    var spinner : UIView?
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = UIImage.init(named: "MIXRLogo")
        self.navigationItem.titleView = UIImageView.init(image: image)
    }
    
    @IBAction func onInputOnePressed(_ sender: UIButton) {
        displayInstrumentSelectionForInput(1)
    }
    
    @IBAction func onInputTwoPressed(_ sender: Any) {
        displayInstrumentSelectionForInput(2)
    }
    
    func displayInstrumentSelectionForInput(_ inputNumber: Int) {
        let actionsheet = UIAlertController(title: "Input \(inputNumber)", message: nil, preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Male Vocals", style: .default, handler: { (action) -> Void in
            self.setTitle(number: inputNumber, text: "Male Vocals")
        }))
        actionsheet.addAction(UIAlertAction(title: "Female Vocals", style: .default, handler: { (action) -> Void in
            self.setTitle(number: inputNumber, text: "Female Vocals")
        }))
        actionsheet.addAction(UIAlertAction(title: "Guitar - Pop", style: .default, handler: { (action) -> Void in
            self.setTitle(number: inputNumber, text: "Guitar - Pop")
        }))
        actionsheet.addAction(UIAlertAction(title: "Guitar - Generic", style: .default, handler: { (action) -> Void in
            self.setTitle(number: inputNumber, text: "Guitar - Generic")
        }))
        actionsheet.addAction(UIAlertAction(title: "No Instrument", style: .default, handler: { (action) -> Void in
            self.setTitle(number: inputNumber, text: "No Instrument")
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        }))
        
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    func setTitle(number : Int, text : String) {
        if number == 1 {
            labelOne.text = text
        }
        else {
            labelTwo.text = text
        }
    }
    
    @IBAction func onContinuePressed(_ sender: Any) {
        if (labelOne.text == "Input 1" || labelTwo.text == "Input 2") {
            let alert = UIAlertController(title: "Set All Inputs", message: "Please make sure that all of your inputs are set", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else if (labelOne.text == "No Instrument" && labelTwo.text == "No Instrument") {
            let alert = UIAlertController(title: "No Instruments", message: "Please make sure that an instrument is present at one of the inputs", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            sendInstruments { (success) in
                self.hideRetry(bool: true)
                if (success) {
                    self.performSegue(withIdentifier: "SelectInstrumentSegue", sender: self)
                }
                else {
                    self.showConnectivityError()
                }
            }
            
        }
    }
    
    func showConnectivityError() {
        let alertController = UIAlertController(title: "Connection not Found", message: "Please make sure that you are connected to the MIXR Wifi and your device is turned on", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Home", style: .destructive, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
            self.sendInstruments { (success) in
                self.hideRetry(bool: true)
                if (success) {
                    self.performSegue(withIdentifier: "SelectInstrumentSegue", sender: self)
                }
                else {
                    self.showConnectivityError()
                }
            }
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true) { }
        }
    }
    
    func hideRetry(bool : Bool) {
        DispatchQueue.main.async {
            self.spinner?.removeFromSuperview()
            self.spinner = nil
        }
    }
    
    func sendInstruments(completionHandler: @escaping CompletionHandler) {
        spinner = UIView.init(frame: view.bounds)
        spinner?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinner!.center
        
        DispatchQueue.main.async {
            self.spinner?.addSubview(ai)
            self.view.addSubview(self.spinner!)
        }
        
        guard let url = URL(string: "http://192.168.4.1:8089/setinstruments") else { return }
        var request = URLRequest(url: url)
        request.setValue("setinstruments", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: String] = [
            "one": labelOne.text ?? "",
            "two": labelTwo.text ?? ""
        ]
        request.httpBody = parameters.percentEncoded()
        request.timeoutInterval = TimeInterval(exactly: 5)!

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse, error == nil else {
                    print("error", error ?? "Unknown error")
                    completionHandler(false)
                    return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                completionHandler(false)
                return
            }
            
            _ = String(data: data, encoding: .utf8)
            completionHandler(true)
        }.resume()
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
