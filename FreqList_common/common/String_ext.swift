//
//  String_ext.swift
//  FreqList
//
//  Created by ricsi on 2019. 01. 18..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

extension String {

    /// Convenience function to replace a Character at Index
    mutating func replaceCharacter(atIndex i: String.Index, with char: Character) {
        self.replaceSubrange(i...i, with: [char])
    }
    
}

// --------------------------------------------------------------------------------------------

extension Substring {
    
    /// Convenience function to replace a Character at Index
    mutating func replaceCharacter(atIndex i: String.Index, with char: Character) {
        self.replaceSubrange(i...i, with: [char])
    }
    
    /// Convenient cast to String
    var string: String { return String(self) }
}
