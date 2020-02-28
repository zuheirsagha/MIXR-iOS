//
//  RecordToPlayBackSegue.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-07-02.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

class RecordToPlayBackSegue : UIStoryboardSegue {
    override func perform() {
        guard let recordVC = self.source as? RecordViewController,
            let playBackVC = self.destination as? PlayBackViewController,
            let playBackView = playBackVC.view,
            let audioPlayerView = playBackVC.audioPlayerView,
            let recordView = recordVC.recordView else { return }
        
        playBackVC.modalPresentationStyle = .fullScreen
        
        playBackVC.navigationItem.setHidesBackButton(true, animated: false)
        
        let rightNavigationBarItem = UIBarButtonItem(title: "Done", style: .done, target: playBackVC, action: Selector(("returnToHomeScreen")))
        playBackVC.navigationItem.setRightBarButton(rightNavigationBarItem, animated: true)

        let screenHeight = UIScreen.main.bounds.size.height/2
        let center = recordVC.view!.center
        let appdel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        playBackView.alpha = 0
        appdel.window!.addSubview(playBackView)
        
        audioPlayerView.visualizerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        audioPlayerView.visualizerCenterView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        audioPlayerView.slider.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        audioPlayerView.playPauseButton.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        audioPlayerView.timeRemaining.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        audioPlayerView.currentTime.transform = CGAffineTransform(translationX: 0, y: screenHeight)

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            
            recordView.stopButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            recordView.recordButtonCenter.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            recordView.timerLabel.transform = CGAffineTransform(translationX: 0, y: screenHeight)
            
        }, completion: { (finished) in
            if finished {
                playBackView.center = CGPoint(x: center.x, y: center.y)
                playBackView.alpha = 1
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    
                    audioPlayerView.visualizerView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    audioPlayerView.visualizerCenterView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    audioPlayerView.slider.transform = CGAffineTransform(translationX: 0, y: 0)
                    audioPlayerView.playPauseButton.transform = CGAffineTransform(translationX: 0, y: 0)
                    audioPlayerView.timeRemaining.transform = CGAffineTransform(translationX: 0, y: 0)
                    audioPlayerView.currentTime.transform = CGAffineTransform(translationX: 0, y: 0)
                    
                }, completion: { (finished) in
                    if finished {
                        self.source.navigationController?.pushViewController(self.destination, animated: false)
                    }
                })
            }
        })
    }
}
