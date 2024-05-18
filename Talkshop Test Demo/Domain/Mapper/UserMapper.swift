//
//  UserMapper.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 18/05/24.
//

import Foundation

struct UserMapper {
    
    static func transformUserResponse(user: [ResponseUser]) -> [User] {
        user.map { user in
                .init(userId: user.userId,
                      userName: user.userName,
                      userImage: nil)
        }
    }
    
}
