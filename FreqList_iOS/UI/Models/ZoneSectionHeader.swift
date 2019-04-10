//
//  ZoneSectionHeader.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 02. 12..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

class ZoneSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var zoneNameLabel: UILabel!
    
    var zoneName: String? {
        didSet {
            zoneNameLabel.text = zoneName
        }
    }

}
