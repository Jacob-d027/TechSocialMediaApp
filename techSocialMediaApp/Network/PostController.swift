//
//  PostController.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/7/24.
//

import Foundation

class PostController {
    enum PostError: Error, LocalizedError {
        case postsNotFound
    }
    
    func fetchPosts(userSecret: UUID, pageNumber: Int?) async throws -> [Post] {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/posts")!)
        
        let credentials: [String: Any] = ["userSecret": userSecret, "pageNumber": pageNumber ?? 0]
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PostError.postsNotFound
        }
        
        let decoder = JSONDecoder()
        let posts = try decoder.decode([Post].self, from: data)
        
        return posts
    }
}
