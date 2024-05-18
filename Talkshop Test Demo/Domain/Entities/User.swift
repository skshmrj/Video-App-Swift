//
//  User.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import UIKit

struct User: Hashable {
    let userId: String
    let userName: String
    let userImage: UIImage?
}


extension User {
    
    static let currentUser = User(userId: "user_A", userName: "Nico Robin", userImage: UIImage.displayPicture)
    
}