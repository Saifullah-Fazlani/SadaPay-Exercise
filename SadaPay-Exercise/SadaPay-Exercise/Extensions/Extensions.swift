//
//  Extensions.swift
//  SadaPay-Exercise
//
//  Created by Saifullah on 19/06/2021.
//

import UIKit
import Foundation

extension UIView {

    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func setBorders(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
