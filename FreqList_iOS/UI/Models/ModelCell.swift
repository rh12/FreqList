//
//  ModelCell.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 02. 12..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

class ModelCell: FLCheckButtonCell {

    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SETUP
    // --------------------------------------------------------------------------------------------

    func configure(withModel model: Model, animated: Bool = false) {
        let checked = model.isAllChecked
        
        // set Model properties
        nameLabel.text = model.name
        smallerLabel.text = model.maker
        smallerLabel.isHidden = (model.maker == nil)
        checkButton.isChecked = checked
        
        // update colors
        updateColors(sourceColor: model.color ?? Channel.Color(gray: 1.0),
                     useColors: model.zone.project.hasColors,
                     animated: animated)
    }
    
    override func doColorConfig(_ state: CellState) {
        super.doColorConfig(state)
    }
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    GENERAL
    // --------------------------------------------------------------------------------------------
    
}
