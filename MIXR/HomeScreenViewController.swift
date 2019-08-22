//
//  HomeScreenViewController.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-07-21.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

class HomeScreenViewController : UIViewController {
    @IBOutlet weak var newTrackView: UIView!
    @IBOutlet weak var listenView: UIView!
    @IBOutlet weak var MIXRDeviceView: RoundedView!
    
    @IBAction func onNewTrackPressed(_ sender: UIButton) {
        print("New Track")
        performSegue(withIdentifier: "NewTrackSegue", sender: self)
    }
    
    @IBAction func onListenPressed(_ sender: UIButton) {
        print("Listen")
        performSegue(withIdentifier: "ListenToTrackSegue", sender: self)
    }
}
