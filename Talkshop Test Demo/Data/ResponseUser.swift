//
//  ResponseUser.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import Foundation

/// A struct representing a user received from the network response.
struct ResponseUser: Decodable {
    /// The unique identifier of the user.
    let userId: String
    
    /// The name of the user.
    let userName: String
    
    /// The URL of the user's thumbnail image.
    let thumbnailUrl: String
}
