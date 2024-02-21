//
//  PostController.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/7/24.
//

import Foundation

class PostController {
    enum PostError: Error, LocalizedError {
        case postsNotFound, unexpectedStatusCode, invalidUserSecret, serverError, unableToEditPost, invalidUserID
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
    
    func createNewPost(title: String, bodyText: String) async throws -> Post {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/createPost")!)
        
        let post: [String: String] = [
            "title": title,
            "body": bodyText
        ]
        
        let requestBody: [String: Any] = [
            "userSecret": User.current!.secret.uuidString,
            "post": post
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PostError.unexpectedStatusCode
        }
        
        let decoder = JSONDecoder()
        let newPost = try decoder.decode(Post.self, from: data)
        
        return newPost
    }
    
    func fetchUserPosts(pageNumber: Int?) async throws -> [Post] {
        var urlComponents = URLComponents(string: "\(API.url)/userPosts")!
        urlComponents.queryItems = [
            URLQueryItem(name: "userSecret", value: User.current!.secret.uuidString),
            URLQueryItem(name: "userUUID", value: User.current!.userUUID.uuidString),
            URLQueryItem(name: "pageNumber", value: String(pageNumber ?? 0))
        ]
        
        let session = URLSession.shared
        var request = URLRequest(url: urlComponents.url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let error = response as? HTTPURLResponse
            if error?.statusCode == 400 {
                throw PostError.invalidUserSecret
            } else if error?.statusCode == 500 {
                throw PostError.serverError
            } else {
                throw PostError.unexpectedStatusCode
            }
        }
        
        let decoder = JSONDecoder()
        let userPosts = try decoder.decode([Post].self, from: data)
        
        return userPosts
    }

    func editExistingPost(postID: Int, title: String, body: String) async throws -> String {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/editPost")!)
        
        let post: [String: Any] = [
            "postid": postID,
            "title": title,
            "body": body
        ]
        
        let requestBody: [String: Any] = [
            "userSecret": User.current!.secret.uuidString,
            "post": post
        ]
        
        request.httpMethod = "POST"
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PostError.unexpectedStatusCode
        }
        
        let decoder = JSONDecoder()
        let message = try decoder.decode(Message.self, from: data)
        
        return message.message
    }
}

struct Message: Decodable {
    var message: String
}
