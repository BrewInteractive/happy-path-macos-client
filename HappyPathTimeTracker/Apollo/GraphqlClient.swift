//
//  DirectusClient.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import Foundation
import Apollo
import KeychainSwift

class GraphqlClient {
    private(set) var client: ApolloClient? = nil
    let endpointURL = URL(string: "https://app.usehappypath.com/hooks/graphql")!
    
    init(token: String) {
        if !token.isEmpty {
            let store = ApolloStore()
            let interceptorProvider = NetworkInterceptorProvider(interceptors: [
                TokenInterceptor(id: K.token, token: token)
            ], store: store)
            
            let networkTransport = RequestChainNetworkTransport(interceptorProvider: interceptorProvider, endpointURL: endpointURL)
            
            self.client = ApolloClient(networkTransport: networkTransport, store: store)
        } else {
            HappyLogger.logger.critical("There is any token in graphql client")
        }
    }
}
