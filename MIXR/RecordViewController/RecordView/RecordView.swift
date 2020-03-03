//
//  RecordSongView.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-06-29.
//  Copyright © 2019 MIXR. All rights reserved.
//
//@IBInspectable var borderColor: UIColor? {
//    didSet {
//        layer.borderColor = borderColor?.CGColor
//        layer.borderWidth = 1
//    }
//}
import UIKit

protocol RecordingDelegate {
    func startedRecording()
    func finishedRecording()
    func hitRecordButton()
    func hitStopButton()
    func MIXRDisconnected()
}

@IBDesignable
class RecordView: UIView {
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    @IBOutlet weak var innerMIXROutline: RoundedView!
    @IBOutlet weak var stopButton: RoundedButton!
    @IBOutlet weak var recordButtonCenter: RoundedButton!
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    var timerCtr = 0
    
    var nibName = "RecordView"
    var view : UIView!
    var delegate : RecordingDelegate?
    var timer: Timer?
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        timerLabel.alpha = 0
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    @IBAction func stopButtonPressed(_ sender: RoundedButton) {
        delegate?.hitStopButton()
        sendState(state: "stop") { (success) in
            if success {
                DispatchQueue.main.async {
                    self.recordButtonCenter.isEnabled = true
                    self.delegate?.finishedRecording()
                    self.timerLabel.layer.removeAllAnimations()
                    self.timer?.invalidate()
                    self.stopButton.isUserInteractionEnabled = false
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                        self.stopButton.cornerRadius = 50
                        self.stopButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.stopButton.bgColor = .clear
                        self.recordButtonCenter.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }) { (finished) in
                        if finished {
                            self.recordView.bringSubviewToFront(self.recordButtonCenter)
                        }
                    }
                }
            }
            else {
                self.delegate?.MIXRDisconnected()
            }
        }
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        delegate?.hitRecordButton()
        sendState(state: "record") { (success) in
            if (success) {
                DispatchQueue.main.async {
                    self.recordButtonCenter.isEnabled = false
                    self.recordView.bringSubviewToFront(self.stopButton)
                    self.stopButton.isUserInteractionEnabled = true
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 15, options: .curveEaseInOut, animations: {
                        self.stopButton.cornerRadius = 16
                        self.stopButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                        self.stopButton.bgColor = .white
                        self.recordButtonCenter.transform = CGAffineTransform(scaleX: 250/83, y: 250/83)
                    })
                    self.timerLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    self.timerLabel.text = "3"
                    self.animateCountdown("3")
                }
            }
            else {
                self.delegate?.MIXRDisconnected()
            }
        }
    }
    
    func sendState(state: String, completionHandler: @escaping CompletionHandler) {
        let url : URL?
        if state == "record" {
            url = URL(string: "http://192.168.4.1:8089/record")
        }
        else {
            url = URL(string: "http://192.168.4.1:8089/stop")
        }

        guard let u = url else { return }

        var request = URLRequest(url: u)
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
    
    func animateCountdown(_ text : String) {
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
            self.timerLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.timerLabel.alpha = 1
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.timerLabel.alpha = 0
                }, completion: { (finished) in
                    if finished {
                        guard let num = Int(text) else { return }
                        self.timerLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        if num - 1 > 0 {
                            self.timerLabel.text = "\(num - 1)"
                            self.animateCountdown("\(num - 1)")
                        }
                        else if num - 1 == 0 {
                            self.timerLabel.text = "GO"
                            self.animateCountdown("0")
                        }
                        else {
                            self.delegate?.startedRecording()
                            if self.timer == nil {
                                self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                                             target: self,
                                                             selector: #selector(self.animateTimer),
                                                             userInfo: nil,
                                                             repeats: true)
                                if let timer = self.timer {
                                    RunLoop.current.add(timer, forMode: .common)
                                }
                                self.timer?.tolerance = 0.1
                                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                                    self.timerLabel.alpha = 1
                                    self.timerLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                                })
                            }
                            self.animateTimer()
                        }
                    }
                })
            }
        }
    }
    
    @objc
    func animateTimer() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.timerCtr = self.timerCtr + 1
            self.timerLabel.text = self.getTime(self.timerCtr)
        })
    }
    
    public func getTime(_ seconds : Int) -> String {
        if seconds/60 < 10 {
            if seconds%60 < 10 {
                return "0\(seconds/60):0\(seconds%60)"
            }
            else {
                return "0\(seconds/60):\(seconds%60)"
            }
        }
        else {
            if seconds%60 < 10 {
                return "\(seconds/60):0\(seconds%60)"
            }
            else {
                return "\(seconds/60):\(seconds%60)"
            }
        }
    }
}
