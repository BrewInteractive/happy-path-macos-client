//
//  AppState.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 2.07.2023.
//

import Foundation
import KeychainSwift

@MainActor
final class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published private(set) var graphqlClient: GraphqlClient? = nil
    let keychain = KeychainSwift()
    
    init() {
        let token = keychain.get(K.token)
        if token != nil {
            graphqlClient = GraphqlClient(token: token!)
        }
    }
    
    func updateClientAuthToken(token: String) {
        // TOOD: burada client i update etmek yerine interceptor guncellenebiliyorsa onu yapmak daha mantikli olabilir
        graphqlClient = GraphqlClient(token: token)
    }
}
