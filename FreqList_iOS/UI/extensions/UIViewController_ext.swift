//
//  UIViewController_ext.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 02. 10..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// appDelegate reference
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // --------------------------------------------------------------------------------------------

    /// Presents an Alert with given title/message, and an OK button
    func presentErrorAlert(title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}
