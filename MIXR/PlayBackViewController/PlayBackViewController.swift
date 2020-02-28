//
//  PlayBackViewController.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-07-02.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

class PlayBackViewController : UIViewController {
    @IBOutlet weak var audioPlayerView: AudioPlayerView!
    var selectedSong = "happy"
    @IBOutlet weak var songLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = UIImage.init(named: "MIXRLogo")
        self.navigationItem.titleView = UIImageView.init(image: image)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayerView.playPauseButton.setImage(UIImage(named: "Play"), for: .normal)
        audioPlayerView.player?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songLabel.text = selectedSong
        audioPlayerView.songName = selectedSong
        audioPlayerView.setupPlayer()
    }
    
    @objc func returnToHomeScreen() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
