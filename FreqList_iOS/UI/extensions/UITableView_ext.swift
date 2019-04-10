//
//  UITableView_ext.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 02. 18..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Scrolls to the first visible selected row, if there is any.
    /// Does not scroll if the first selected row is not visible before the transition.
    /// Should be called from 'viewWillTransition(to:, with:)'
    func scrollToSelectedRow(with coordinator: UIViewControllerTransitionCoordinator) {
        if let selectedIP = indexPathForSelectedRow,
            isIndexPathVisible(selectedIP) {
            coordinator.animate(alongsideTransition: { [unowned self] coordinator in
                self.scrollToRow(at: selectedIP, at: .none, animated: false)
            })
        }
    }
    
    /// Returns wether the given index path is visible.
    func isIndexPathVisible(_ ip: IndexPath) -> Bool {
        return indexPathsForVisibleRows?.contains(ip) ?? false
    }
    
}

