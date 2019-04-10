//
//  Loggers.swift
//  FreqList
//
//  Created by ricsi on 2019. 01. 20..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

// --------------------------------------------------------------------------------------------
// MARK:-    PROTOCOL
// --------------------------------------------------------------------------------------------

protocol Logger {
    var logString: String { get }
    func log(indent: Int, char: Character)
}

extension Logger {
    //// TODO: indent should be decided (also?) at logString level,
    ////   because I want to indent when building encompassing logString
    func log(indent: Int = 0, char: Character = " ") {
        if indent == 0 {
            // print without indentation
            print(logString)
        } else {
            // print indenting each line
            let spaces = String(repeating: char, count: indent)
            logString.split(separator: "\n").forEach({
                print(spaces + $0)
            })
        }
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    EXTENSIONS for built-in types
// --------------------------------------------------------------------------------------------


// --------------------------------------------------------------------------------------------
// MARK:-    EXTENSIONS for custom types
// --------------------------------------------------------------------------------------------

extension Channel: Logger {
    var logString: String {
        return """
        ZONE: \(model.zone.name),  MODEL: \(model.name),
          NAME: \(chName),  ID: \(deviceID), FREQ: \(freqString)
        """
    }
}


extension Zone: Logger {
    var logString: String {
        var s = "ZONE: \(name)  [\(allChannels.count)]\n"
        for m in models {
            s += "  MODEL: \(m.name)  [\(m.channels.count)]\n"
            for ch in m.channels {
                s += "    NAME: \(ch.chName),  ID: \(ch.deviceID), FREQ: \(ch.freqString)\n"
            }
        }
        return s
    }
}
