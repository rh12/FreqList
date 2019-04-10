//
//  ChannelCell.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 02. 12..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

class ChannelCell: FLCheckButtonCell {

    @IBOutlet weak var freqLabel: UILabel!
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SETUP
    // --------------------------------------------------------------------------------------------

    func configure(withChannel ch: Channel, animated: Bool = false) {
        // set Channel properties
        nameLabel.text = ch.chName
        smallerLabel.text = ch.deviceID
        freqLabel.text = ch.freqString
        checkButton.isChecked = ch.isChecked
        
        // update colors
        updateColors(sourceColor: ch.color,
                     useColors: ch.model.zone.project.hasColors,
                     animated: animated)
    }
    
    override func doColorConfig(_ state: CellState) {
        super.doColorConfig(state)
        
        switch state {
        case .unchecked:
            freqLabel.textColor = AC.color.Cell.black
        case .checked:
            nameLabel.textColor = AC.color.Cell.black
            smallerLabel.textColor = AC.color.Cell.darkGray
            freqLabel.textColor = AC.color.Cell.checkedTextGray
        case .highlighted:
            fallthrough
        case .selected:
            freqLabel.textColor = AC.color.Cell.white
        }
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    GENERAL
    // --------------------------------------------------------------------------------------------


}
