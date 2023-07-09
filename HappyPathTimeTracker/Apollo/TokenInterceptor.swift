//
//  TokenInterceptor.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import Foundation
import Apollo
import ApolloAPI

class TokenInterceptor: ApolloInterceptor {
    var id: String
    let token: String?
    
    init(id: String, token: String) {
        self.id = id
        self.token = token
    }
    
    func interceptAsync<Operation>(chain: RequestChain, request: HTTPRequest<Operation>, response: HTTPResponse<Operation>?, completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) where Operation : GraphQLOperation {
        if let token, !token.isEmpty {
            request.addHeader(name: "Authorization", value: "Bearer \(token)")
        }
        chain.proceedAsync(request: request, response: response, interceptor: self , completion: completion)
    }
}
