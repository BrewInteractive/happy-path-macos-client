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
    static func readLogs() throws {
        let store = try OSLogStore(scope: .currentProcessIdentifier)
        let startOfDay = store.position(date: Date().dateAtStartOf(.day))
        let entries = try store.getEntries(with: [], at: startOfDay, matching: .none)
            .compactMap({$0 as? OSLogEntryLog})
            .filter({$0.subsystem == subsystem})
        for entry in entries {
            print("\(entry.date.toISO()): message: \(entry.composedMessage)")//TODO: create an email template with these and send to the happy path macos team
        }
    }
}
