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
    
    init(id: String, token: String?) {
        self.id = id
        self.token = token ?? "WyIweGM3YzNjOWJlYzQ1OWYwZTdhZDJkNGFjMDMwYzNkMjZlNzkxZTQzZWY3ZWRkZjkwMGVlNjU1YTI0MTJkMzViMzY3NTk3NTQwNjU4NjEzMjA1NmQ2ZmY1MWQ2NjQwYTk3NTg3MWMwZmFhOWExOTZiMDYzMGFlNjI0NzA1YjgwYzQ2MWMiLCJ7XCJpYXRcIjoxNjg4ODMzNjMyLFwiZXh0XCI6MTY4ODgzNDUzMixcImlzc1wiOlwiZGlkOmV0aHI6MHhDYjBDRTllNUEzREI2ZGY3NjQyQjMxZDFjNEFBODMzRjVBMDUyMTM2XCIsXCJzdWJcIjpcIlJFWTc0S0tZY2ducmY0OGs4dDVnejJFTndmYThDczhGQTFYOUtfeVVXU2M9XCIsXCJhdWRcIjpcIlRhX0RicXo0SG9mc1lESk9BRzlINVNpdHVscFVRZjk1VGFuNWZGV2NwNTA9XCIsXCJuYmZcIjoxNjg4ODMzNjMyLFwidGlkXCI6XCI3ODQ0Y2VjZS1lMjBmLTQxNTMtOGU4NS1hOTkzYTMzZjhjMzhcIixcImFkZFwiOlwiMHhhYTU3ZTMxMTEzMjQ0YzQzNTUyMjI0NWQ4NmYzNDZkMTMxNzdiN2JkN2FmMzQyMGRkMzlmNmZhOWM1NDAzMzUxNTM2NjY2NDZjZDdlMjkzN2IxM2IyZWRhMjBmOTJhYTEwZGVhYzQ1YWFiMWZhYjkzNjQ2MjVhOTg1MjQxNzE3ZjFjXCJ9Il0="
    }
    
    func interceptAsync<Operation>(chain: RequestChain, request: HTTPRequest<Operation>, response: HTTPResponse<Operation>?, completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) where Operation : GraphQLOperation {
        if let token, !token.isEmpty {
            request.addHeader(name: "Authorization", value: "Bearer \(token)")
        }
        chain.proceedAsync(request: request, response: response, interceptor: self , completion: completion)
    }
}
