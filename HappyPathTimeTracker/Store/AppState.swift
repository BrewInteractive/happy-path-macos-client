//
//  AppState.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 2.07.2023.
//

import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var token: String?
    @Published private(set) var graphqlClient: GraphqlClient? = nil
    
    init() {
        let keystore = KeyStore()
        if let sharedKeychain = keystore.retrieve(key: K.token) {
            print(sharedKeychain)
            _token = Published(wrappedValue: sharedKeychain)
            graphqlClient = GraphqlClient(token: sharedKeychain)
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
        let store = KeyStore()
        store.store(key: K.token, value: token)
        isLoggedIn = true
        self.token = token
        updateClientAuthToken(token: token)
    }
}
