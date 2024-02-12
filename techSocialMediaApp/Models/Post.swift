//
//  Post.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/7/24.
//

import Foundation

struct Post: Decodable, Encodable {
    var postid: String
    var title: String
    var body: String
    var authorUserName: String
    var authorUserID: String
    var likes: Int
    var userLiked: Bool
    var numComments: Int
    var createdDateString: String
    var createdDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: createdDateString) ?? Date()
    }
    var comments: [Comment]
    
    
}
