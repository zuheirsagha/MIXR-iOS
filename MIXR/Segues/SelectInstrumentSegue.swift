//
//  SelectInstrumentSegue.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2020-02-27.
//  Copyright © 2020 MIXR. All rights reserved.
//

import UIKit

class SelectInstrumentSegue : UIStoryboardSegue {
    override func perform() {
        let src = self.source as! InputSelectionViewController
        let dst = self.destination as! RecordViewController
        src.navigationController?.pushViewController(dst, animated: true)
    }
}
