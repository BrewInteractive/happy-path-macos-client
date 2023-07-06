//
//  DirectusClient.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import Foundation
import Apollo

class GraphqlClient {
    private var client: ApolloClient
    let endpointURL = URL(string: "https://app.usehappypath.com/hooks/graphql")!
    
    init() {
        let store = ApolloStore()
        //TODO: need to read token from db
        let interceptorProvider = NetworkInterceptorProvider(interceptors: [
            TokenInterceptor(id: "token", token: nil)
        ], store: store)
        
        let networkTransport = RequestChainNetworkTransport(interceptorProvider: interceptorProvider, endpointURL: endpointURL)
        
        self.client = ApolloClient(networkTransport: networkTransport, store: store)
    }
    
    func getClient() -> ApolloClient {
        return self.client
    }
}
