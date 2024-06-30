//
//  AppDelegate.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 9.07.2023.
//

import Foundation
import AppKit
import SwiftDate
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // set default region
        SwiftDate.defaultRegion = .local
    }
}
