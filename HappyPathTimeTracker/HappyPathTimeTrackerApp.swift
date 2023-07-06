//
//  HappyPathTimeTrackerApp.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 26.06.2023.
//

import SwiftUI

@main
struct HappyPathTimeTrackerApp: App {
    @StateObject private var appState = AppState()
    @Environment(\.openWindow) private var openWindow
//    @Environment(\.openURL) private var openUrl
    
    var body: some Scene {
        MenuBarExtra("extra title", systemImage: "hammer") {
            MainScreen()
                .environmentObject(appState)
                .onAppear {
                    openWindow(id: "login")
                }
        }.menuBarExtraStyle(.window)
        
        WindowGroup("Login", id: "login") {
            LoginScreen()
                .environmentObject(appState)
        }
    }
}
