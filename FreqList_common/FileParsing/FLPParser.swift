//
//  FLPParser.swift
//  FreqList
//
//  Created by ricsi on 2019. 03. 04..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

/// Helper class to parse FreqList Project (.FLP) files
class FLPParser: FileParsing {
    
    static func parseFile(_ url: URL, forProject project: Project) throws {
        let error = FileParserError.processError("FreqList Project (.FLP)")
        
        // open XML
        guard let data = try? Data(contentsOf: url) else { throw FileParserError.fileOpenError }
        guard let xml = try? AEXMLDocument(xml: data) else { throw error }
        let xmlRoot = xml.root
        
        // get Project
        let xmlProject = xml.root
        guard xmlProject.name == "project" else { throw error }
        
        // clear all previous data
        project.clear()
        
        // process XML
        for xmlZone in xmlRoot["zone"].all ?? [] {
            // create Zone
            guard let zName = xmlZone.attributes["name"] else { throw error }
            let zone = Zone(name: zName, project: project)
            project.zones.append(zone)
            
            for xmlModel in xmlZone["model"].all ?? [] {
                // create Model
                guard let mProduct = xmlModel.attributes["product"],
                    let mBand = xmlModel.attributes["band"]
                    else { throw error }
                let mMaker = xmlModel.attributes["maker"]
                let model = Model(maker: mMaker, product: mProduct, band: mBand, zone: zone)
                zone.models.append(model)
                
                for xmlChannel in xmlModel["channel"].all ?? [] {
                    // create Channel
                    let channel = Channel(model: model)
                    model.channels.append(channel)
                    
                    // setup Channel
                    if let chName = xmlChannel.attributes["name"] {
                        channel.chName = chName
                    }
                    if let deviceID = xmlChannel.attributes["deviceID"] {
                        channel.deviceID = deviceID
                    }
                    if let freq = xmlChannel.attributes["freq"] {
                        channel.setFrequency(khz: freq)
                    }
                    if let checked = xmlChannel.attributes["checked"] {
                        channel.isChecked = (checked == "true")
                    }
                    if let color = xmlChannel.attributes["color"] {
                        channel.color = Channel.Color(hex: color)
                    }
                }
            }
        }
        
        // finish setup
        project.setupColors()
    }
    
}
