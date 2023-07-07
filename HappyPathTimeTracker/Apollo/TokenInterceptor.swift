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
        self.token = token ?? "WyIweGFjNGFmNGY4YzhjNGQzZDYxZmNlMzQzOGYyZjM2YTljZmJlZDZmNjQ3NjJiOTk5Zjg4MGVmZGUwZWJjM2E0NDQyMzk0MGVlOTMxNzJmNTMwNGFiZmRhNDFiZmY3YjdhNzNiNjllMDJkNmQ2M2Y5M2JhM2Q5MzU4ZjFjZjMxY2M0MWMiLCJ7XCJpYXRcIjoxNjg4NzA0NTgzLFwiZXh0XCI6MTY4ODcwNTQ4MyxcImlzc1wiOlwiZGlkOmV0aHI6MHhDYjBDRTllNUEzREI2ZGY3NjQyQjMxZDFjNEFBODMzRjVBMDUyMTM2XCIsXCJzdWJcIjpcIlJFWTc0S0tZY2ducmY0OGs4dDVnejJFTndmYThDczhGQTFYOUtfeVVXU2M9XCIsXCJhdWRcIjpcIlRhX0RicXo0SG9mc1lESk9BRzlINVNpdHVscFVRZjk1VGFuNWZGV2NwNTA9XCIsXCJuYmZcIjoxNjg4NzA0NTgzLFwidGlkXCI6XCI5NjllOGFlZS0yMGVjLTRiZTEtOWJiYS0wYzBkZTI0ZGMyNzhcIixcImFkZFwiOlwiMHhhYTU3ZTMxMTEzMjQ0YzQzNTUyMjI0NWQ4NmYzNDZkMTMxNzdiN2JkN2FmMzQyMGRkMzlmNmZhOWM1NDAzMzUxNTM2NjY2NDZjZDdlMjkzN2IxM2IyZWRhMjBmOTJhYTEwZGVhYzQ1YWFiMWZhYjkzNjQ2MjVhOTg1MjQxNzE3ZjFjXCJ9Il0="
    }
    
    func interceptAsync<Operation>(chain: RequestChain, request: HTTPRequest<Operation>, response: HTTPResponse<Operation>?, completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) where Operation : GraphQLOperation {
        if let token, !token.isEmpty {
            request.addHeader(name: "Authorization", value: "Bearer \(token)")
        }
        chain.proceedAsync(request: request, response: response, interceptor: self , completion: completion)
    }
}
