//
//  UIAlertController.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 19/05/24.
//

import UIKit

extension UIAlertController {
    
    // Convenience initializer for error alerts
    convenience init(errorMessage: String) {
        self.init(title: "error".localized, message: errorMessage, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "dismiss".localized, style: .default, handler: nil))
    }
}

