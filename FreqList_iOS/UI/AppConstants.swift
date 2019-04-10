//
//  AppConstants.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 02. 19..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit


// --------------------------------------------------------------------------------------------
// MARK:-    COLORS
// --------------------------------------------------------------------------------------------

extension AC.color {
    enum CheckButton {
        static let green = UIColor(named: "CheckButton/green")!
        static let white = UIColor(named: "CheckButton/white")!
        static let darkGray = UIColor(named: "CheckButton/darkGray")!
        static let lightGray = UIColor(named: "CheckButton/lightGray")!
        static let border = UIColor(named: "CheckButton/border")!
    }
    
    enum Cell {
        static let black = UIColor(named: "Cell/black")!
        static let darkGray = UIColor(named: "Cell/darkGray")!
        static let white = UIColor(named: "Cell/white")!
        static let checkedTextGray = UIColor(named: "Cell/checkedTextGray")!
        static let checkedBGGray = UIColor(named: "Cell/checkedBGGray")!
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    STRINGS
// --------------------------------------------------------------------------------------------

extension AC.string {
    enum Check {
        static let checked = "✓"
        static let unchecked = "✗"
    }
    
    enum Sort {
        static let asc = "↓"
        static let desc = "↑"
        static let upDown = "↑↓"
        static let downUp = "↓↑"
    }
    
    static let lastUsedFile = "lastUsed.flp"
}


// --------------------------------------------------------------------------------------------
// MARK:-    NIBS
// --------------------------------------------------------------------------------------------

extension AC.nib {
    static let ZoneSectionHeader = "ZoneSectionHeader"
    static let ModelCell = "ModelCell"
    static let ChannelCell = "ChannelCell"
}


// --------------------------------------------------------------------------------------------
// MARK:-    ITEMIDS
// --------------------------------------------------------------------------------------------

extension AC.itemID {
    enum ModelsVC {
        static let ZoneSectionHeader = "ZoneSectionHeader"
        static let ModelCell = "ModelCell"
    }
    
    enum ChannelsVC {
        static let ChannelCell = "ChannelCell"
    }
    
}


// --------------------------------------------------------------------------------------------
// MARK:-    TIME INTERVALS
// --------------------------------------------------------------------------------------------

extension AC.time {
    static let deselectOnCheck: TimeInterval = 0.3
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
    
    struct time {
        private init() {}
    }
}
