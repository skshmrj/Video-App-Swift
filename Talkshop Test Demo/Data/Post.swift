//
//  Post.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 15/05/24.
//

import Foundation

struct Post: Decodable {
    let postId: String
    let videoUrl: String
    let thumbNailUrl: String
    let username: String
    let likeCount: Int
}
