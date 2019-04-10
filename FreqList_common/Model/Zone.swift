//
//  Zone.swift
//  FreqList
//
//  Created by ricsi on 2019. 01. 20..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

class Zone {
    unowned let project: Project

    var name: String
    var models: [Model] = []
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    INIT
    // --------------------------------------------------------------------------------------------
    
    init(name: String, project: Project) {
        self.name = name
        self.project = project
    }
    

    // --------------------------------------------------------------------------------------------
    // MARK:-    SUBSCRIPTS + COMPUTED
    // --------------------------------------------------------------------------------------------

    /// Returns the Model for the given index
    subscript(index: Int) -> Model {
        return models[index]
    }
    
    /// Returns Channel array of the given Model.
    subscript(model: Model) -> [Channel] {
        if let m = models.first(where: { $0 === model }) {
            return m.channels
        }
        return []
    }
    
    // --------------------------------------------------------------------------------------------

    /// Returns all Channels in Zone
    var allChannels: [Channel] {
        var all = [Channel]()
        for m in models {
            all += m.channels
        }
        return all
    }
    
    /// Returns whether all Channels are checked
    var isAllChecked: Bool {
        return !models.contains {$0.isAllChecked == false}
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SETUP
    // --------------------------------------------------------------------------------------------
    
    /// Returns a Model with matching Product and Band.
    /// Creates & adds it, if it did not exist.
    func getOrAddModel(maker: String? = nil, product: String, band: String) -> Model {
        // get model
        var model = models.first { $0.maker == maker && $0.product == product && $0.band == band }
        
        // create & append model
        if model == nil {
            model = Model(maker: maker, product: product, band: band, zone: self)
            models.append(model!)
        }
        
        return model!
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    GENERAL
    // --------------------------------------------------------------------------------------------
    
    func checkAll(_ check: Bool) {
        models.forEach {$0.checkAll(check)}
    }
    
}


// --------------------------------------------------------------------------------------------
// MARK:-    EXTENSIONS
// --------------------------------------------------------------------------------------------

extension Zone: Equatable {
    static func ==(lhs: Zone, rhs: Zone) -> Bool {
        return lhs.name == rhs.name
    }
}
