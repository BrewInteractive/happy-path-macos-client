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
    
    var body: some Scene {
        MenuBarExtra("extra title", systemImage: "hammer") {
            MainScreen()
                .environmentObject(appState)
        }.menuBarExtraStyle(.window)
    }
}
