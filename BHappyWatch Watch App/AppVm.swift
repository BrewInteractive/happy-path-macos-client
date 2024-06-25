//
//  AppVm.swift
//  BHappyWatch Watch App
//
//  Created by Gorkem Sevim on 23.06.2024.
//

import Foundation
import Combine

@MainActor
final class AppVm: ObservableObject {
    @Published var token: String = ""
    @Published var isLoading = true
    @Published var isLoggedIn = false
    
    init() {
        let store = KeyStore()
        if let keychainToken = store.retrieve(key: K.token) {
            _token = Published(wrappedValue: keychainToken)
        } else {
            print("token nil")
        }
    }
    
    func initialize() async {
        if let _ = await Requests.me(token: token) {
            isLoggedIn = true
            isLoading = false
        } else {
            isLoggedIn = false
            isLoading = false
        }
    }
}
