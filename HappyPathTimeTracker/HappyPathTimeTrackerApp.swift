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
        MenuBarExtra {
            MainScreen()
                .environmentObject(appState)
                .onAppear {
                    let keychain = KeychainSwift()
                    let token = keychain.get(K.token)
                    if token != nil {
                        self.appState.updateAppStateProp(for: \.isLoggedIn, newValue: true)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name.loginByMagicLinkNotification)) { token in
                    self.appState.updateAppStateProp(for: \.isLoggedIn, newValue: true)
                    appState.updateClientAuthToken(token: token.object as! String)
                }
        } label: {
            let image: NSImage = {
                    let ratio = $0.size.height / $0.size.width
                $0.isTemplate = true
                    $0.size.height = 16
                    $0.size.width = 16 / ratio
                    return $0
                }(NSImage(named: "brew")!)
                Image(nsImage: image)
        }
        .menuBarExtraStyle(.window)
    }
}
