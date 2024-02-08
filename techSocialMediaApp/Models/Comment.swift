//
//  Comment.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/7/24.
//

import Foundation

struct Comment: Decodable, Encodable {
    var commentID: Int
    var body: String
    var userName: String
    var userID: String
    var createdDate: String
}
