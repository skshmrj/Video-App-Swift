//
//  AppStyle.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import UIKit

/// A structure that defines the overall style for the application.
struct AppStyle {
    
    /// A structure that defines spacing constants used throughout the application.
    struct Spacing {
        /// Small spacing value
        static let small: CGFloat = 8
        
        /// Medium spacing value
        static let medium: CGFloat = 16
        
        /// Default spacing value
        static let `default`: CGFloat = 20
        
        /// Large spacing value
        static let large: CGFloat = 32
    }
    
    /// A structure that defines color constants used throughout the application.
    struct Color {
        /// Primary color of the app, defined in the asset catalog as "AppTheme".
        static let primaryColor = UIColor(named: "AppTheme")
        
        /// Background color of the app, defined in the asset catalog as "AppBackground".
        static let backgroundColor = UIColor(named: "AppBackground")
        
        /// Secondary background color of the app, defined in the asset catalog as "AppSecondaryBackground".
        static let secondaryBackgroundColor = UIColor(named: "AppSecondaryBackground")
    }
    
    /// A structure that defines radius constants used throughout the application.
    struct Radius {
        /// Default corner radius
        static let `default`: CGFloat = 16
        
        /// Shadow radius
        static let shadowRadius: CGFloat = 8
    }
    
    /// A structure that defines font styles used throughout the application.
    struct Font {
        /// Font style for headers, with size 26 and bold weight.
        static let header = UIFont.systemFont(ofSize: 26, weight: .bold)
        
        /// Font style for titles, with size 20 and bold weight.
        static let title = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        /// Font style for body text, with size 16 and semibold weight.
        static let body = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        /// Font style for captions, with size 11 and light weight.
        static let caption = UIFont.systemFont(ofSize: 11, weight: .light)
    }
}
