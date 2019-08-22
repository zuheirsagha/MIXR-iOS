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
    
    @IBAction func onBackButtonPressed(_ sender: UIButton) {
        audioPlayerView.player?.stop()
        self.performSegue(withIdentifier: "BackToTracksSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        songLabel.text = selectedSong
        audioPlayerView.songName = selectedSong
        audioPlayerView.setupPlayer()
    }
}
