//
//  TimeEntry.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import Foundation

struct TimeEntry: Identifiable {
    let id: Int
    let projectId: Int
    let projectName: String
    let taskId: Int
    let taskName: String
    let notes: String
    let startsAt: String
    let endsAt: String
    let totalDuration: Int
}
