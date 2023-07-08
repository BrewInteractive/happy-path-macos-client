//
//  Date.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 8.07.2023.
//

import Foundation

extension Date {
    var startOfDayISO: String {
        self.dateAtStartOf(.day).date.toISO()
    }
    
    var endOfDayISO: String {
        self.dateAtEndOf(.day).date.toISO()
    }
}
