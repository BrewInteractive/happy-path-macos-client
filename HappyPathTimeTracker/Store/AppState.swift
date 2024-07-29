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
        if let keychainValue = keychainStore.get(K.token), !keychainValue.isEmpty {
            _token = Published(wrappedValue: keychainValue)
            graphqlClient = GraphqlClient(token: keychainValue)
            isLoggedIn = true
            HappyLogger.logger.log("user is authenticated")
        } else {
            isLoggedIn = false
            HappyLogger.logger.log("user is not authenticated")
        }
    }
    
    func executeLoginPrecess(token: String) {
        isLoggedIn = true
        self.token = token
        graphqlClient = GraphqlClient(token: token)
        Task.detached {
            let keychainStore = KeychainSwift()
            keychainStore.set(token, forKey: K.token)
        }
    }
    
    func logout() {
        isLoggedIn = false
        token = nil
        graphqlClient = nil
        Task.detached {
            let keychainStore = KeychainSwift()
            keychainStore.set("", forKey: K.token)
        }
    }
}
