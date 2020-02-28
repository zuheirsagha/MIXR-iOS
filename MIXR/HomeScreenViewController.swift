//
//  HomeScreenViewController.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-07-21.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

class HomeScreenViewController : UIViewController {
    @IBOutlet weak var buttonsView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let logo = UIImage(named: "MIXRLogo")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
    
    @IBAction func onNewSongPressed(_ sender: Any) {
        print("New Track")
        performSegue(withIdentifier: "NewTrackSegue", sender: self)
    }
    
    @IBAction func onListenPressed(_ sender: UIButton) {
        print("Listen")
        performSegue(withIdentifier: "ListenToTrackSegue", sender: self)
    }
}

class MyNavigationBar: UINavigationBar {
    override func popItem(animated: Bool) -> UINavigationItem? {
        return super.popItem(animated: false)
    }
}
