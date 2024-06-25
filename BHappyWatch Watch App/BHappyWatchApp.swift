//
//  BHappyWatchApp.swift
//  BHappyWatch Watch App
//
//  Created by Gorkem Sevim on 23.06.2024.
//

import SwiftUI

@main
struct BHappyWatch_Watch_AppApp: App {
    @StateObject private var appVm = AppVm()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appVm.isLoading {
                    ProgressView()
                } else {
                    if appVm.isLoggedIn {
                        MainScreen()
                            .environmentObject(appVm)
                    } else {
                        Text("please login from your mac app")
                    }
                }
            }
            .task {
                await appVm.initialize()
            }
        }
    }
}
