//
//  UserMapper.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import Foundation

/// A utility struct responsible for mapping response users to domain users.
struct UserMapper {
    
    /// Transforms an array of response users to an array of domain users.
    ///
    /// - Parameter user: The array of response users.
    /// - Returns: An array of domain users.
    static func transformUserResponse(user: [ResponseUser]) -> [User] {
        user.map { user in
                .init(userId: user.userId,
                      userName: user.userName,
                      userImage: nil)
        }
    }
    
}
