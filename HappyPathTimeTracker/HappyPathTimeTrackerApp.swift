//
//  HappyPathTimeTrackerApp.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 26.06.2023.
//

import SwiftUI
import KeychainSwift

@main
struct HappyPathTimeTrackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        MenuBarExtra("extra title", systemImage: "hammer") {
            MainScreen()
                .environmentObject(appState)
                .onAppear {
                    let keychain = KeychainSwift()
                    let token = keychain.get(K.token)
                    if token != nil {
                        DispatchQueue.main.async {
                            appState.updateIsLoggedIn(newValue: true)
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name.loginByMagicLinkNotification)) { token in
                    appState.updateIsLoggedIn(newValue: true)
                    appState.updateClientAuthToken(token: token.object as! String)
                }
        }.menuBarExtraStyle(.window)
    }
}

//TODO: herhango bir istekten 403 gelirse appState isLoggedIn false olmali, combine ile kontrol edilebilir
