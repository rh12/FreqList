//
//  UINavigationItem_ext.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 02. 20..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    /// Enables/disables all RightBarButtonItems
    func enableRightBarButtonItems(_ enable: Bool) {
        rightBarButtonItems?.forEach {$0.isEnabled = enable}
    }
}
