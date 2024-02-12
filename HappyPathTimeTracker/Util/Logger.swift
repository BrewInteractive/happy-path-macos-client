//
//  Logger.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 12.02.2024.
//

import Foundation
import OSLog

final class HappyLogger {
    private static let subsystem = Bundle.main.bundleIdentifier!
    private static let category = "happy-macos"
    static let logger = Logger(subsystem: subsystem, category: category)
//    static func readLogs() throws {
//        let store = try OSLogStore.local()
//        let startOfDay = store.position(date: .now.dateAtStartOf(.day))
//        let entries = try store.getEntries(with: [], at: startOfDay, matching: .none)
//        for entry in entries {
//            print(entry.description)
//        }
//    }
}
