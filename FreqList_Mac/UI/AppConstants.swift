//
//  AppConstants.swift
//  FreqList for Mac
//
//  Created by ricsi on 2019. 02. 22..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation



// --------------------------------------------------------------------------------------------
// MARK:-    COLORS
// --------------------------------------------------------------------------------------------

extension AC.color {
    
}


// --------------------------------------------------------------------------------------------
// MARK:-    STRINGS
// --------------------------------------------------------------------------------------------

extension AC.string {
    
}


// --------------------------------------------------------------------------------------------
// MARK:-    NIBS
// --------------------------------------------------------------------------------------------

extension AC.nib {
    
}


// --------------------------------------------------------------------------------------------
// MARK:-    ITEMIDS
// --------------------------------------------------------------------------------------------

extension AC.itemID {
    enum ZonesOutline {
        static let zoneCell = NSUIItemID("zoneCell")
        static let modelCell = NSUIItemID("modelCell")
    }
    
    enum ChannelsTable {
        static let nameColumn = NSUIItemID("nameColumn")
        static let deviceIDColumn = NSUIItemID("deviceIDColumn")
        static let freqColumn = NSUIItemID("freqColumn")
        static let modelColumn = NSUIItemID("modelColumn")
        
        static let nameCell = NSUIItemID("nameCell")
        static let deviceIDCell = NSUIItemID("deviceIDCell")
        static let freqCell = NSUIItemID("freqCell")
        static let modelCell = NSUIItemID("modelCell")
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    AC STRUCT
// --------------------------------------------------------------------------------------------

struct AC {
    private init() {}
    
    struct color {
        private init() {}
    }
    
    struct string {
        private init() {}
    }
    
    struct nib {
        private init() {}
    }
    
    struct itemID {
        private init() {}
    }
}
