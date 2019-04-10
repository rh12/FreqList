//
//  NSViewController_ext.swift
//  FreqList for Mac
//
//  Created by ricsi on 2019. 01. 17..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Cocoa

extension NSViewController {
    
    // appDelegate reference
    var appDelegate: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
}
