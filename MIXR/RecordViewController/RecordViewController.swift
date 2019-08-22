//
//  ViewController.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-06-29.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, RecordingDelegate {
    
    @IBOutlet weak var recordView: RecordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordView.delegate = self
    }
    
    func startedRecording() {
        print("started recording")
    }
    
    func finishedRecording() {
        print("finished recording")
        if recordView.timerCtr > 0 {
            let alertController = UIAlertController(title: "Name your song", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.autocapitalizationType = .sentences
                textField.autocorrectionType = .no
            }
            alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                guard let text = alertController.textFields?.first?.text else { return }
                if text.count == 0 {
                    alertController.message = "Please enter a name with at least one character"
                    self.present(alertController, animated: true, completion: {})
                }
                else {
                    //TODO: segue
                    self.performSegue(withIdentifier: "idRecordToPlayBackSegue", sender: self)
                }
            }))
            self.present(alertController, animated: true) { }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PlayBackViewController {
            destinationVC.selectedSong = "Mena Solo"
        }
    }
}

