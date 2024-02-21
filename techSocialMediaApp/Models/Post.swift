//
//  Post.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/7/24.
//

import Foundation

struct Post: Decodable, Encodable {
    var postid: Int
    var title: String
    var body: String
    var authorUserName: String
    var authorUserId: UUID
    var likes: Int
    var userLiked: Bool
    var numComments: Int
    var createdDate: String
//    var comments: [Comment]
    
    enum PostCodingKeys: String, CodingKey {
        case postid
        case title
        case body
        case authorUserName
        case authorUserId
        case likes
        case userLiked
        case numComments
        case createdDate
    }
}

