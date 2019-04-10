//
//  FileManager_ext.swift
//  FreqList
//
//  Created by ricsi on 2019. 02. 25..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

extension FileManager {
    
    /// Returns the application's Documents directory.
    static var documentsDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
