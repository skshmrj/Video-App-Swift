//
//  User.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import UIKit

/// A struct representing a user.
struct User: Hashable {
    /// The unique identifier of the user.
    let userId: String
    
    /// The username of the user.
    let userName: String
    
    /// An optional image representing the user's profile picture.
    let userImage: UIImage?
}

extension User {
    
    /// A static instance representing the current user.
    static let currentUser = User(userId: "user_A", userName: "Nico Robin", userImage: UIImage.displayPicture)
}
