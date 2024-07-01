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
    @Published var token: String?
    @Published private(set) var graphqlClient: GraphqlClient? = nil
    
    init() {
        let keychainStore = KeychainSwift()
        if let keychainValue = keychainStore.get(K.token) {
            print(keychainValue)
            _token = Published(wrappedValue: keychainValue)
            graphqlClient = GraphqlClient(token: keychainValue)
            isLoggedIn = true
            HappyLogger.logger.log("user is authenticated")
        } else {
            isLoggedIn = false
            HappyLogger.logger.log("user is not authenticated")
        }
    }
    
    private func updateClientAuthToken(token: String) {
        // TOOD: burada client i update etmek yerine interceptor guncellenebiliyorsa onu yapmak daha mantikli olabilir
        graphqlClient = GraphqlClient(token: token)
    }
    
    func executeLoginPrecess(token: String) {
        let keychainStore = KeychainSwift()
        keychainStore.set(token, forKey: K.token)
        isLoggedIn = true
        self.token = token
        updateClientAuthToken(token: token)
    }
}
