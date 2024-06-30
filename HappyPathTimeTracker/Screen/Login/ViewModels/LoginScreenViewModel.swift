//
//  LoginScreenViewModel.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 29.06.2024.
//

import Foundation
import Combine

@MainActor
final class LoginScreenViewModel: ObservableObject {
    var appState: AppState? = nil
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isErrorShown = false
    @Published var isLoading = false
    
    func initialize(appState: AppState) {
        self.appState = appState
    }
    
    func login(email: String, password: String) async {
        guard let appState = appState else { return }
        isLoading = true
        if let token = await NetworkManager.login(email: email, password: password) {
            appState.executeLoginPrecess(token: token)
        } else {
            isErrorShown = true
        }
        isLoading = false
    }
}
