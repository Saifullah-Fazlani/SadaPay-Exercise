//
//  Extensions.swift
//  SadaPay-Exercise
//
//  Created by Saifullah on 19/06/2021.
//

import UIKit
import Foundation

enum URLConstant: String {
    case baseURL = "https://api.github.com"
    case repositoryList = "/search/repositories?q=language=+sort:stars"
}

struct Strings {
    static let networkUnreachable = "Looks like your network is not reachable :("
    static let invalidResponse = "Invalid response"
    static let unableToDecode = "Unable to decode JSON data!"
    static let signalBlocked = "An alien is probably blocking your signal."
}

extension UIView {
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func setBorders(width: CGFloat, color: UIColor, cornerRadius: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = cornerRadius
    }
}
