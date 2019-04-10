//
//  UIColor_ChannelColor.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 03. 08..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(channelColor chColor: Channel.Color, checked: Bool = false) {
        let mult: CGFloat = checked ? 0.75 : 1.0
        let alpha: CGFloat = checked ? 0.4 : 1.0
        self.init(red: chColor.r * mult,
                  green: chColor.g * mult,
                  blue: chColor.b * mult,
                  alpha: alpha)
    }
}

