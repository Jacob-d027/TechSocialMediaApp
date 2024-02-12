//
//  PostController.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/7/24.
//

import Foundation

class PostController {
    enum PostError: Error, LocalizedError {
        case postsNotFound, unexpectedStatusCode
    }
    func fetchPosts(pageNumber: Int?) async throws -> [Post] {
        var urlComponents = URLComponents(string: "\(API.url)/posts")!
        urlComponents.queryItems = [
            URLQueryItem(name: "userSecret", value: User.current?.secret.uuidString),
            URLQueryItem(name: "pageNumber", value: String(pageNumber ?? 0))
        ]
        
        let session = URLSession.shared
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PostError.unexpectedStatusCode
        }
        
        let decoder = JSONDecoder()
        let posts = try decoder.decode([Post].self, from: data)
        
        return posts
    }

}
