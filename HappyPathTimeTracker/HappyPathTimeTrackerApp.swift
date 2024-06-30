//
//  HappyPathTimeTrackerApp.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 26.06.2023.
//

import SwiftUI

@main
struct HappyPathTimeTrackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        MenuBarExtra {
            MainScreen()
                .environmentObject(appState)
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
