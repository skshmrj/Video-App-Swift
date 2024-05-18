//
//  Post.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

struct ResponsePost: Decodable {
    let postId: String
    let videoUrl: String
    let thumbNailUrl: String
    let userId: String
    let userName: String
    let likeCount: Int
}
