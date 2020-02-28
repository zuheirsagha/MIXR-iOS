//
//  InputSelectionViewController.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2020-02-27.
//  Copyright © 2020 MIXR. All rights reserved.
//

import UIKit

class InputSelectionViewController : UIViewController {
    
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
            self.performSegue(withIdentifier: "SelectInstrumentSegue", sender: self)
        }
    }
    
    
}
