//
//  AppState.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 2.07.2023.
//

import Foundation
import KeychainSwift

class AppState: ObservableObject {
    @Published private(set) var isLoggedIn = false
    @Published private(set) var graphqlClient: GraphqlClient? = nil
    
    init() {
        let keychain = KeychainSwift()
        let token = keychain.get(K.token)
        if token != nil {
            graphqlClient = GraphqlClient(token: token!)
        }
    }
    
    func updateIsLoggedIn(newValue: Bool) {
        self.isLoggedIn = newValue
    }
    
    func updateClientAuthToken(token: String) {
        // TOOD: burada client i update etmek yerine interceptor guncellenebiliyorsa onu yapmak daha mantikli olabilir
        graphqlClient = GraphqlClient(token: token)
    }
}
