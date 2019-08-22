//
//  StartWithoutMIXRSegue.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-07-21.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

class StartWithoutMIXRSegue : UIStoryboardSegue {
    override func perform() {
        let src = self.source as UIViewController
        let dst = self.destination as UIViewController
        src.present(dst, animated: false, completion: {
            
        })
    }
}
