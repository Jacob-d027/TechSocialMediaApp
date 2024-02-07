//
//  APIController.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/7/24.
//

import Foundation

class APIController {
    static let shared = APIController()
    
    enum APIError: Error, LocalizedError {
        case userDetailsNotFound
    }
    
    func fetchUserDetails(userUUID: UUID, userSecret: UUID) async throws -> Bool {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/userProfile")!)
        
        let credentials: [String: Any] = ["userUUID": userUUID, "userSecret": userSecret]
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.userDetailsNotFound
        }
        
        let decoder = JSONDecoder()
        let userDetails = try decoder.decode(User.self, from: data)
        
        User.current = userDetails
        
        return true
    }
}
