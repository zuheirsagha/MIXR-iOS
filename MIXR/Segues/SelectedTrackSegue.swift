//
//  SelectedTrackSegue.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-07-24.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

class SelectedTrackSegue : UIStoryboardSegue {
    override func perform() {
        let src = self.source as UIViewController
        let dst = self.destination as! PlayBackViewController
        src.navigationController?.pushViewController(dst, animated: true)
    }
}
