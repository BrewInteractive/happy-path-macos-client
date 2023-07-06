//
//  LoginScreen.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 2.07.2023.
//

import Foundation
import SwiftUI
import AppKit

struct LoginScreen: View {
    
    var body: some View {
        Text("login screen")
            .onAppear {
                for window in NSApplication.shared.windows where window.isKeyWindow {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        window.close()
                    }
                }
            }
    }
}
