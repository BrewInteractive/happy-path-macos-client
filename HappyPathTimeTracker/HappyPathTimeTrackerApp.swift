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
                        HappyLogger.logger.log("user is authenticated")
                        self.appState.isLoggedIn = true
                    } else {
                        HappyLogger.logger.log("user is not authenticated")
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name.loginByMagicLinkNotification)) { token in
                    self.appState.isLoggedIn = false
                    appState.updateClientAuthToken(token: token.object as! String)
                }
                .environment(\.font, .figtree())
                .frame(width: 400, height: 450)
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
