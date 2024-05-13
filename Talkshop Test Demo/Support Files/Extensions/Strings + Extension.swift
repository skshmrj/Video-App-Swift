//
//  Strings + Extension.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
