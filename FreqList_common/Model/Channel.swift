//
//  Channel.swift
//  FreqList
//
//  Created by ricsi on 2019. 01. 20..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

class Channel {
    unowned let model: Model
    
    var chName: String = ""
    var deviceID: String = ""
    
    private var mhzString: String = "0"
    private var khzString: String = "0"
    private(set) var freq: Int = 0                          // kHz
    private(set) var freqString: String = ""                // mhz.khz (using default delimiter)

    var isChecked: Bool = false
    var color: Color = Color(gray: 1.0)
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    INIT
    // --------------------------------------------------------------------------------------------
    
    init(model: Model) {
        self.model = model
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SUBSCRIPTS + COMPUTED
    // --------------------------------------------------------------------------------------------
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SETUP
    // --------------------------------------------------------------------------------------------

    /// Sets all frequency properties.
    /// - parameter mhz: String representation in mHz. Format: "123" or "1234"
    /// - parameter khz: String representation in kHz. Format: "123"
    /// - parameter delimiter: mHz/kHz delimiter to use in 'freqString'. Default: "."
    func setFrequency(mhz: String, khz: String, delimiter: String = ".") {
        guard let mhzValue = Int(mhz), mhzValue > 0,
            let khzValue = Int(khz), khzValue >= 0
            else { clearFrequency(); return }

        mhzString = mhz
        khzString = khz
        freqString = mhz + delimiter + khz
        freq = mhzValue * 1000 + khzValue
    }
    
    /// Sets all frequency properties.
    /// - parameter khz: String representation in kHz. Format: "123456" or "1234567"
    /// - parameter delimiter: mHz/kHz delimiter to use in 'freqString'. Default: "."
    func setFrequency(khz: String, delimiter: String = ".") {
        guard let khzValue = Int(khz), khzValue > 0
            else { clearFrequency(); return }
        
        setFrequency(mhz: khz.dropLast(3).string,
                     khz: khz.suffix(3).string,
                     delimiter: delimiter)
    }
    
    /// Clears all frequency properties.
    private func clearFrequency() {
        mhzString = "0"
        khzString = "0"
        freqString = ""
        freq = 0
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    GENERAL
    // --------------------------------------------------------------------------------------------

}


// --------------------------------------------------------------------------------------------
// MARK:-    EXTENSIONS
// --------------------------------------------------------------------------------------------

extension Channel: Equatable {
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.chName == rhs.chName &&
            lhs.deviceID == rhs.deviceID &&
            lhs.freqString == rhs.freqString
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    SORTING
// --------------------------------------------------------------------------------------------

extension Channel {
    enum SortKey: String {
        case model
        case chName
        case deviceID
        case freqString
    }
}

