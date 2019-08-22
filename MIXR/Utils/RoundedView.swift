//
//  RoundedView.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-06-29.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
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
    
    @IBInspectable var bgColor: UIColor? {
        didSet {
            layer.backgroundColor = bgColor?.cgColor
        }
    }
}
