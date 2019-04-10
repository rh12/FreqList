//
//  Channel_Color.swift
//  FreqList
//
//  Created by ricsi on 2019. 03. 08..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation
import CoreGraphics.CGGeometry


extension Channel {
    
    /// Stores rgb values, converts to/from hex string.
    /// Using UIColor/CGColor/NSColor was not target-independent enough (iOS vs macOS)
    struct Color {
        var r, g, b: CGFloat
        
        // --------------------------------------------------------------------------------------------
        
        var hex: String {
            return String(format: "%02x%02x%02x",
                          Int(r * CGFloat(255)),
                          Int(g * CGFloat(255)),
                          Int(b * CGFloat(255)))
        }
        
        var isWhite: Bool {
            return r == 1 && g == 1 && b == 1
        }
        
        var isBlack: Bool {
            return r == 0 && g == 0 && b == 0
        }
        
        // --------------------------------------------------------------------------------------------
        
        init(r: CGFloat, g: CGFloat, b: CGFloat) {
            self.r = r
            self.g = g
            self.b = b
        }
        
        init(gray: CGFloat) {
            self.init(r: gray, g: gray, b: gray)
        }
        
        init() {
            self.init(gray: 1.0)
        }
        
        init(hex: String) {
            var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            if (hex.hasPrefix("#")) { hex.removeFirst() }
            guard hex.count == 6 else { self.init(); return }
            
            var rgbValue:UInt32 = 0
            Scanner(string: hex).scanHexInt32(&rgbValue)
            self.init(uint32: rgbValue)
        }
        
        init(uint32 rgbValue: UInt32) {
            self.init(r: CGFloat((rgbValue & 0xFF0000) >> 16) / CGFloat(255),
                      g: CGFloat((rgbValue & 0x00FF00) >> 8) / CGFloat(255),
                      b: CGFloat(rgbValue & 0x0000FF) / CGFloat(255))
        }
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    EXTENSIONS
// --------------------------------------------------------------------------------------------

extension Channel.Color: Equatable {
    static func == (lhs: Channel.Color, rhs: Channel.Color) -> Bool {
        return lhs.r == rhs.r &&
            lhs.g == rhs.g &&
            lhs.b == rhs.b
    }
}
