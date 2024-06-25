//
//  Requests.swift
//  BHappyWatch Watch App
//
//  Created by Gorkem Sevim on 23.06.2024.
//

import Foundation

final class Requests {
    static func getTimers(token: String) async throws -> TimersResponse? {
        let variables: [String: String] = [
            "startsAt": "2024-06-23T00:00:00Z",
            "endsAt": "2024-06-23T23:59:59Z"
        ]
        
        // Prepare the JSON request payload
        let requestPayload: [String: Any] = [
            "query": Graphqls.timers,
            "variables": variables
        ]
        
        do {
            let data = try await graphqlRequest(payload: requestPayload, token: token)
            let response = try JSONDecoder().decode(TimersResponse.self, from: data)
            return response
        } catch {
            print("Error: \(error)")
        }
        
        return nil
    }
    
    static func me(token: String) async -> MeResponse? {
        let requestPayload: [String: Any] = [
            "query": Graphqls.me,
            "variables": [:]
        ]
        
        do {
            let data = try await graphqlRequest(payload: requestPayload, token: token)
            let response = try JSONDecoder().decode(MeResponse.self, from: data)
            return response
        } catch {
            print("Error: \(error)")
        }
        
        return nil
    }
    
    private static func graphqlRequest(payload: [String: Any], token: String) async throws -> Data {
        guard let url = URL(string: "https://app.usehappypath.com/hooks/graphql") else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add the authentication header with Bearer token
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            throw error
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return data
//        do {
//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                return json
//            } else {
//                throw URLError(.cannotParseResponse)
//            }
//        } catch {
//            throw error
//        }
    }
}
