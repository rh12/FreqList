//
//  UIColor_ext.swift
//  FreqList
//
//  Created by ricsi on 2019. 03. 07..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation
import UIKit.UIColor

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (hex.hasPrefix("#")) {
            hex.removeFirst()
        }
        guard hex.count == 6 else { self.init(); return }
        
        var rgbValue:UInt32 = 0
        Scanner(string: hex).scanHexInt32(&rgbValue)
        
        self.init(red:   CGFloat((rgbValue & 0xFF0000) >> 16) / CGFloat(255),
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / CGFloat(255),
                  blue:  CGFloat(rgbValue & 0x0000FF) / CGFloat(255),
                  alpha: alpha)
    }
    
    var hex: String {
        guard cgColor.numberOfComponents == 4 else { return "" }
        
        let c = cgColor.components!.map { Int($0 * CGFloat(255)) }
        return String(format: "%02x%02x%02x", c[0], c[1], c[2])
    }
}
