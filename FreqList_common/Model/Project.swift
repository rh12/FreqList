//
//  Project.swift
//  FreqList
//
//  Created by ricsi on 2019. 01. 17..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

class Project {

    var zones: [Zone] = []
    
    private(set) var hasColors = false
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    INIT
    // --------------------------------------------------------------------------------------------
    
    init() {
        // does nothing
    }
    
    init(fromURL url: URL) throws {
        try constructFromFile(url)
    }
    
    // --------------------------------------------------------------------------------------------
    
    private func constructFromFile(_ url: URL) throws {
        if let parser = FileTypes.parserForURL(url) {
            try parser.parseFile(url, forProject: self)
        } else {
            throw FileParserError.customError("Unknown filetype.")
        }
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SUBSCRIPTS + COMPUTED
    // --------------------------------------------------------------------------------------------

    /// Returns all Channels in all Zones.
    var allChannels: [Channel] {
        var all = [Channel]()
        for z in zones {
            all += z.allChannels
        }
        return all
    }
    
    /// Returns whether the Manager has any data.
    var hasData: Bool {
        return zones.count > 0
    }

    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SETUP
    // --------------------------------------------------------------------------------------------
    
    /// Returns a Zone with matching Name.
    /// Creates & adds it, if it did not exist.
    func getOrAddZone(name: String) -> Zone {
        // get zone
        var zone = zones.first { $0.name == name }
        
        // create & append zone
        if zone == nil {
            zone = Zone(name: name, project: self)
            zones.append(zone!)
        }
        
        return zone!
    }
    
    // --------------------------------------------------------------------------------------------

    func setupColors() {
        for zone in zones {
            for model in zone.models {
                model.setupColor()
                // if any model has color different than white
                if hasColors == false && (model.color == nil || !model.color!.isWhite) {
                    hasColors = true
                }
            }
        }
    }

    
    // --------------------------------------------------------------------------------------------
    // MARK:-    GENERAL
    // --------------------------------------------------------------------------------------------

    /// Clears all Zone, Model and Channel data
    func clear() {
        zones.removeAll()
    }
    
    // --------------------------------------------------------------------------------------------

    /// Sorts the models in each Zone, by name, ascending
    func sortModels() {
        for zone in zones {
            zone.models.sort { $0.name < $1.name }
        }
    }
    
    /// Sorts the channels of each Model.
    func sortChannels(by key: Channel.SortKey, ascending: Bool) {
        let gtlt: (String, String) -> Bool = ascending ? (<) : (>)

        for zone in zones {
            for model in zone.models {
                switch key {
                case .model:
                    model.channels.sort { gtlt($0.model.name, $1.model.name) }
                case .chName:
                    model.channels.sort { gtlt($0.chName, $1.chName) }
                case .deviceID:
                    model.channels.sort { gtlt($0.deviceID, $1.deviceID) }
                case .freqString:
                    model.channels.sort { gtlt($0.freqString, $1.freqString) }
                }
            }
        }
    }
    
    /// Sorts the channels of each Model, using the SortDescriptors 'key' and 'ascending' parameters.
    func sortChannels(usingSortDescriptor sd: NSSortDescriptor) {
        guard let sdKey = sd.key,
            let key = Channel.SortKey(rawValue: sdKey)
            else { return }
        sortChannels(by: key, ascending: sd.ascending)
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    SAVE FLP
// --------------------------------------------------------------------------------------------
extension Project {
    
    func saveFLP(to fileName: String) {
        // build XML
        let xml = AEXMLDocument()
        let root = xml.addChild(name: "project")
        for zone in zones {
            let zoneDict = ["name":zone.name]
            let xmlZone = root.addChild(name: "zone", value: nil, attributes: zoneDict)
            
            for model in zone.models {
                var modelDict = ["product" : model.product,
                                 "band" : model.band ]
                if let maker = model.maker { modelDict["maker"] = maker }
                let xmlModel = xmlZone.addChild(name: "model", value: nil, attributes: modelDict)
                
                for channel in model.channels {
                    let chDict = ["name" : channel.chName,
                                  "deviceID" : channel.deviceID,
                                  "freq" : String(channel.freq),
                                  "checked" : channel.isChecked ? "true" : "false",
                                  "color" : channel.color.hex]
                    xmlModel.addChild(name: "channel", value: nil, attributes: chDict)
                }
            }
        }
        
        // write to file
        let fileContent = xml.xml
        if let dir = FileManager.documentsDirectory {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                try fileContent.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                print("Could not write file.")
            }
        }
    }
}
