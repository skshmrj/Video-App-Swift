//
//  AppStyle.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import UIKit

struct AppStyle {
    
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let `default`: CGFloat = 20
        static let large: CGFloat = 32
    }
    
    struct Color {
        static let primaryColor = UIColor(named: "AppTheme")
        static let backgroundColor = UIColor(named: "AppBackground")
        static let secondaryBackgroundColor = UIColor(named: "AppSecondaryBackground")
    }
    
    struct Radius {
        static let `default`: CGFloat = 16
        static let shadowRadius: CGFloat = 8
    }
    
    struct Font {
        static let header = UIFont.systemFont(ofSize: 26, weight: .bold)
        static let title = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let body = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let caption = UIFont.systemFont(ofSize: 11, weight: .light)
    }
}
