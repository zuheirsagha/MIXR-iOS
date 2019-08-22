//
//  RoundedImageView.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-06-29.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor : UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}

public func getTime(_ seconds : Int) -> String {
    if seconds/60 < 10 {
        if seconds%60 < 10 {
            return "0\(seconds/60):0\(seconds%60)"
        }
        else {
            return "0\(seconds/60):\(seconds%60)"
        }
    }
    else {
        if seconds%60 < 10 {
            return "\(seconds/60):0\(seconds%60)"
        }
        else {
            return "\(seconds/60):\(seconds%60)"
        }
    }
}
