//
//  NSTableView_ext.swift
//  FreqList for Mac
//
//  Created by ricsi on 2019. 01. 28..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Cocoa

extension NSTableView {
    
    // Returns a new or existing cell view with the specified identifier.
    func makeCellView(withIdentifier identifier: NSUserInterfaceItemIdentifier, owner: Any? = self) -> NSTableCellView? {
        return self.makeView(withIdentifier: identifier, owner: owner) as? NSTableCellView
    }
    
}
