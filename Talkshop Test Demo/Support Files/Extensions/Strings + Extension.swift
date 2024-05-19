//
//  Strings + Extension.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import Foundation

import Foundation

/// An extension to the `String` class to provide localization functionality.
extension String {
    /// A computed property that returns the localized version of the string.
    ///
    /// This property uses `NSLocalizedString` to look up a localized string by the key specified
    /// by the value of the string itself. 
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
