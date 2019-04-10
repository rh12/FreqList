//
//  WWBShowParser.swift
//  FreqList
//
//  Created by ricsi on 2019. 03. 04..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

/// Helper class to parse WWB Show (.SHW) or WWB Inventory (.INV) files
class WWBShowParser: FileParsing {
    
    static func parseFile(_ url: URL, forProject project: Project) throws {
        let typeOfError = (url.pathExtension == "shw")
            ? "WWB Show (.SHW)" : "WWB Inventory (.INV)"
        let error = FileParserError.processError(typeOfError)
        
        // open XML
        guard let data = try? Data(contentsOf: url) else { throw FileParserError.fileOpenError }
        guard let xml = try? AEXMLDocument(xml: data) else { throw error }
        
        // clear all previous data
        project.clear()
        
        // find Inventory
        let inventoryTag = "inventory"
        let xmlInventory = (xml.root.name == inventoryTag)
            ? xml.root : xml.root[inventoryTag]
        guard xmlInventory.error == nil
            else { throw FileParserError.customError("No Inventory found in file.") }
        
        // process Inventory
        for xmlDevice in xmlInventory["device"].all ?? [] {
            guard
                let zoneName = xmlDevice["zone"].value,
                let modelName = xmlDevice["model"].value,
                let modelBand = xmlDevice["band"].value
                else { throw error }
            let zone = project.getOrAddZone(name: zoneName)
            let model = zone.getOrAddModel(maker: xmlDevice["manufacturer"].value,
                                           product: modelName,
                                           band: modelBand)
            
            let deviceName = xmlDevice["device_name"].string
            let chNameFromDevice = xmlDevice["channel_name"].value
            let freqFromDevice = xmlDevice["frequency"].value

            for xmlChannel in xmlDevice["channel"].all ?? [] {
                let ch = Channel(model: model)
                ch.chName = xmlChannel["channel_name"].value ?? chNameFromDevice ?? ""
                ch.deviceID = deviceName
                ch.setFrequency(khz: xmlChannel["frequency"].value ?? freqFromDevice ?? "")
                
                let xmlColor = xmlChannel["color"]
                if xmlColor.error == nil {
                    if xmlColor.attributes["type"] == "3",
                        let rgb = UInt32(xmlColor.string) {
                        ch.color = Channel.Color(uint32: rgb)
                    } else {
                        ch.color = Channel.Color(hex: xmlColor.string)
                    }
                }
                
                model.channels.append(ch)
            }
        }
        
        // finish setup
        project.setupColors()
    }
    
}
