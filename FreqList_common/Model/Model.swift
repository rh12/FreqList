//
//  Model.swift
//  FreqList
//
//  Created by ricsi on 2019. 01. 28..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

class Model {
    unowned let zone: Zone

    var maker: String?
    var product: String
    var band: String
    var name: String                // display name

    var channels: [Channel] = []
    
    private(set) var color: Channel.Color?

    
    // --------------------------------------------------------------------------------------------
    // MARK:-    INIT
    // --------------------------------------------------------------------------------------------
    
    init(maker: String? = nil, product: String, band: String, zone: Zone) {
        self.maker = maker
        self.product = product
        self.band = band
        self.name = "\(product)  (\(band))"
        self.zone = zone
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SUBSCRIPTS + COMPUTED
    // --------------------------------------------------------------------------------------------

    /// Returns the Channel for the given index
    subscript(index: Int) -> Channel {
        return channels[index]
    }
    
    // --------------------------------------------------------------------------------------------
    
    /// Returns whether all Channels are checked
    var isAllChecked: Bool {
        return !channels.contains {$0.isChecked == false}
    }

    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SETUP
    // --------------------------------------------------------------------------------------------

    func setupColor() {
        guard channels.count > 0 else { return }
        
        let firstColor = channels[0].color
        for ch in channels {
            guard firstColor == ch.color else { return }
        }
        color = firstColor
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    GENERAL
    // --------------------------------------------------------------------------------------------

    func checkAll(_ check: Bool) {
        channels.forEach {$0.isChecked = check}
    }
    
}


// --------------------------------------------------------------------------------------------
// MARK:-    EXTENSION Equatable
// --------------------------------------------------------------------------------------------

extension Model: Equatable {
    static func ==(lhs: Model, rhs: Model) -> Bool {
        return lhs.maker == rhs.maker
            && lhs.product == rhs.product
            && lhs.band == rhs.band
            && lhs.zone === rhs.zone
    }
}
