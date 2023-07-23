//
//  Stats.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 18.07.2023.
//

import Foundation

struct Stats {
    let byDate: [StatsByDate]
    let byInterval: [StatsByInterval]
}

struct StatsByDate {
    let date: String
    let totalDuration: Int
}

struct StatsByInterval {
    let type: String
    let startsAt: String
    let endsAt: String
    let totalDuration: Int
}

