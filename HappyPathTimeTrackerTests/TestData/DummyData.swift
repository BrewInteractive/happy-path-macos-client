//
//  DummyData.swift
//  HappyPathTimeTrackerTests
//
//  Created by Gorkem Sevim on 11.08.2023.
//

import Foundation
@testable import HappyPathTimeTracker

struct DummyData {
    static let timers: [HappyPathTimeTracker.TimeEntry] = [
        .init(id: 1, projectId: 1, projectName: "Tmrw Space", taskId: 2, taskName: "Frontend Dev", notes: "new notes", duration: 123, totalDuration: 123),
        .init(id: 2, projectId: 2, projectName: "Brew", taskId: 3, taskName: "QA Test", notes: "test stories", duration: 123, totalDuration: 123)
    ]
    static let email = "haha@brewww.com"
    
    static let stats = Stats(byDate: [StatsByDate.init(date: Date().startOfDayISO, totalDuration: 123)], byInterval: [StatsByInterval.init(type: IntervalType.Month.rawValue, startsAt: Date().startOfDayISO, endsAt: Date().endOfDayISO, totalDuration: 123)])
    
    static let projects: [Project] = [
        Project(id: 1, name: "Brew")
    ]
    
    static let loggedTimerInfoId = "1"
    static let loggedTimerInfoStartsAt = Date().startOfDayISO
    static let logTimerProjectId = 1
    static let logTimerTaskId = 1
    
    static let updatedTimerId = 1
    static let updatedTimerStartsAt = Date().startOfDayISO
    static let updatedTimerEndsAt = Date().endOfDayISO
    static let updatedTimerTotalDuration = 124
    
    static let startedTimerId = "1"
    static let startedTimerStartsAt = Date().startOfDayISO
    static let startedTimerEndsAt = Date().endOfDayISO
    static let startedTimerDuration = 124
    
    static let stoppedTimerId = timers[0].id
    static let stoppedTimerStartsAt = Date().startOfDayISO
    static let stoppedTimerEndsAt = Date().endOfDayISO
    static let stoppedTimerTotalDuration = 124
    
    static let restartedTimerId = timers[0].id
    static let restartedTimerStartsAt = Date().startOfDayISO
    static let restartedTotalDuration = 124
    
    static let tasks: [ProjectTask] = [
        ProjectTask(id: 1, name: "Frontend Development")
    ]
}
