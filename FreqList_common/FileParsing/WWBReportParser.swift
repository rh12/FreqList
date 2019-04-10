//
//  WWBReportParser.swift
//  FreqList
//
//  Created by ricsi on 2019. 03. 04..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

/// Helper class to parse WWB Report (.CSV) files
class WWBReportParser: FileParsing {
    
    static func parseFile(_ url: URL, forProject project: Project) throws {
        // get lines from CSV
        guard let csv = try? String(contentsOf: url, encoding: String.Encoding.utf8)
            else { throw FileParserError.fileOpenError }
        let lines = csv.split(separator: "\n")
        
        // clear all previous data
        project.clear()
        
        // define constants
        let zonePrefix = "\"Zone: "
        let channelSuffix = ",,"
        let backupPrefix = "Backup Frequencies"
        let exclusionsLine = "\"Exclusions\""
        
        // process each line
        var activeChannels = false
        lineLoop: for line in lines {
            
            switch String(line) {
            case _ where line.hasPrefix(zonePrefix):
                // starting a Zone
                let zoneName = line.dropFirst(zonePrefix.count).dropLast().string
                project.zones.append(Zone(name: zoneName, project: project))
                activeChannels = true
                
            case _ where line.hasSuffix(channelSuffix) && activeChannels:
                // processing Channel
                let chString = line.dropLast(channelSuffix.count).string
                if let currentZone = project.zones.last {
                    try processChannel(chString, forZone: currentZone)
                }
                
            case _ where line.hasPrefix(backupPrefix):
                // starting Backups
                activeChannels = false
                
            case exclusionsLine:
                // starting Exclusions
                activeChannels = false
                break lineLoop
                
            default:
                break
            }
        }
    }
    
    // --------------------------------------------------------------------------------------------
    
    /// Processes a WWB Report CSV line representing a Channel.
    private static func processChannel(_ chString: String, forZone zone: Zone) throws {
        let error = FileParserError.processError("WWB Report (.CSV)")
        var chString = chString
        
//        // remove MHz + Tags
//        //  (assumes Tags dont include " MHz,")
//        let mhzSuffix = " MHz,"
//        guard let mhzRange = chString.range(of: mhzSuffix, options: .backwards) else { throw error }
//        chString.removeSubrange(mhzRange.lowerBound..<chString.endIndex)
        
        // convert possible ",Find Best," to ",0,000 MHz,"
        // UR4S,A24,UHFR 7 blue,0,G:-- Ch:--,Find Best,,,
        // EW 300 IEM G3,G,IEM 8,g3IEM 8,G:-- Ch:--,607,875 MHz,,,
        let fbPart = ",Find Best,"
        let zeroPart = ",0,000 MHz,"
        if let fbRange = chString.range(of: fbPart, options: .backwards) {
            chString.replaceSubrange(fbRange, with: zeroPart)
        }
        
        // remove MHz + Tags
        //  (assumes Tags dont include " MHz,")
        let mhzSuffix = " MHz,"
        guard let mhzRange = chString.range(of: mhzSuffix, options: .backwards) else { throw error }
        chString.removeSubrange(mhzRange.lowerBound..<chString.endIndex)
        
        // convert possible "mhz.khz" to "mhz,khz"
        //  (in case WWB exports using "." (or anything else) as separator
        let delimIndex = chString.index(chString.endIndex, offsetBy: -4)
        chString.replaceCharacter(atIndex: delimIndex, with: ",")
        
        // separate Cells
        let cells = chString.split(separator: ",", omittingEmptySubsequences: false)
        guard cells.count >= 7 else { throw error }
        // 0 (0)  = Model
        // 1 (1)  = Band
        // 2 (-5) = ChName
        // 3 (-4) = DeviceID
        // 4 (-3) = G/CH
        // 5 (-2) = MHz
        // 6 (-1) = KHz
        
        // setup Channel
        let model = zone.getOrAddModel(product: cells[0].string,
                                       band: cells[1].string)
        let ch = Channel(model: model)
        ch.chName = cells[cells.count-5].string
        ch.deviceID = cells[cells.count-4].string
        ch.setFrequency(mhz: cells[cells.count-2].string,
                        khz: cells[cells.count-1].string)
        
        // add Channel
        model.channels.append(ch)
    }
    
}
