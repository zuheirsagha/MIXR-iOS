//
//  InstrumentSelectionViewController.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-07-24.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

class InstrumentSelectionViewController : UIViewController {
    
    let instruments = ["Guitar", "Piano", "MicSelector"]
    var selectedInstrument = "Guitar"
    
    @IBOutlet weak var MIXRRoundedView: RoundedView!
    @IBOutlet weak var inputTitleLabel: UILabel!
    @IBOutlet weak var inputIconButton: UIButton!
    @IBOutlet weak var selectedInstrumentImageView: UIImageView!
    var ctr = 0
    
    override func viewDidLoad() {
        selectedInstrument = instruments[0]
    }
    
    @IBAction func onRightButtonPressed(_ sender: UIButton) {
        ctr = (ctr + 1)%instruments.count
        selectedInstrument = instruments[ctr]
        selectedInstrumentImageView.image = UIImage(named: selectedInstrument)
    }
    @IBAction func onLeftButtonPressed(_ sender: UIButton) {
        ctr = ctr - 1
        if ctr == -1 {
            ctr = 2
        }
        selectedInstrument = instruments[ctr]
        selectedInstrumentImageView.image = UIImage(named: selectedInstrument)
    }
}
