//
//  Bool_ext.swift
//  FreqList
//
//  Created by ricsi on 2019. 02. 17..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

#if !swift(>=4.2)
    extension Bool {
        mutating func toggle() {
            self = !self
        }
    }
#endif


