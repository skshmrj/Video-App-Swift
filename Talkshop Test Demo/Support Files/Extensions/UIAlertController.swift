//
//  UIAlertController.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 19/05/24.
//

import UIKit

import UIKit

/// An extension to the `UIAlertController` class to provide a convenience initializer for error alerts.
extension UIAlertController {
    
    /// A convenience initializer to create an error alert with a localized title and a dismiss button.
    ///
    /// - Parameter errorMessage: The error message to be displayed in the alert.
    ///
    /// This initializer sets up an alert with a localized "error" title and the provided error message.
    /// It also adds a dismiss button with a localized "dismiss" title.
    convenience init(errorMessage: String) {
        // Initialize the UIAlertController with a localized error title and the provided error message
        self.init(title: "error".localized, message: errorMessage, preferredStyle: .alert)
        
        // Add a dismiss action with a localized dismiss title
        self.addAction(UIAlertAction(title: "dismiss".localized, style: .default, handler: nil))
    }
}
