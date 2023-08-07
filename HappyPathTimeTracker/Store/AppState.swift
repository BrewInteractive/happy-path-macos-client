//
//  AppState.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 2.07.2023.
//

import Foundation
import KeychainSwift

class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published private(set) var graphqlClient: GraphqlClient? = nil
    let keychain = KeychainSwift()
    
    init() {
        let token = keychain.get(K.token)
        if token != nil {
            graphqlClient = GraphqlClient(token: token!)
        }
    }
    
    func updateAppStateProp<T>(for keyPath: ReferenceWritableKeyPath<AppState, T>, newValue: T) {
        DispatchQueue.main.async { [weak self] in
            self?[keyPath: keyPath] = newValue
        }
    }
    
    func updateClientAuthToken(token: String) {
        // TOOD: burada client i update etmek yerine interceptor guncellenebiliyorsa onu yapmak daha mantikli olabilir
        graphqlClient = GraphqlClient(token: token)
    }
    
//    func logout() {
//        DispatchQueue.global().async {
//            self.keychain.delete(K.token)
//        }
//        updateAppStateProp(for: \.isLoggedIn, newValue: false)
//    }
}
