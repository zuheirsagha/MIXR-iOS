//
//  AudioPlayerView.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-06-29.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
class AudioPlayerView: UIView {
    
    var nibName = "AudioPlayerView"
    var view : UIView!
    var player : AVAudioPlayer?
    var timer : Timer?
    var songName = "happy"
    @IBOutlet weak var meterView: RoundedView!
    
    @IBOutlet weak var visualizerView: RoundedView!
    @IBOutlet weak var visualizerCenterView: RoundedView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        guard let player = player else { return }
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
    
    @objc func updateSlider(){
        guard let player = player else { return }
        slider.value = Float(player.currentTime)
        // Update time remaining label
        let remainingTimeInSeconds = player.duration - player.currentTime
        timeRemaining.text = "\(getTime(Int(remainingTimeInSeconds)))"
        currentTime.text = "\(getTime(Int(player.currentTime)))"
        
        player.updateMeters()
        var power : Float = 0.0;
        for i in 0..<player.numberOfChannels {
            power += player.averagePower(forChannel: i)
        }
        power /= Float(player.numberOfChannels)
        let scale = 0.6/1*(pow(10.0,(power/20))-1)+1
        UIView.animate(withDuration: 0.001, delay: 0, options: .curveEaseInOut, animations: {
            self.meterView.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        })
    }
    
    func setupPlayer() {
        guard let url = Bundle.main.url(forResource: songName, withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            
            slider.value = 0.0
            slider.maximumValue = Float(player.duration)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
            
            player.prepareToPlay()
            player.isMeteringEnabled = true;
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        guard let player = player else { return }
        if player.isPlaying {
            playPauseButton.setImage(UIImage(named: "Play"), for: .normal)
            player.pause()
        } else {
            playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
            player.play()
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        player?.currentTime = Double(slider.value)
    }
}
