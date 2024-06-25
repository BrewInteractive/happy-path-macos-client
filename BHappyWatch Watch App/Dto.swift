//
//  Dto.swift
//  BHappyWatch Watch App
//
//  Created by Gorkem Sevim on 24.06.2024.
//

import Foundation

struct TimersResponse: Codable {
    let data: TimerData
}

struct TimerData: Codable {
    let timers: [Timer]
}

struct Timer: Codable {
    let id: Int
    let endsAt: String
    let startsAt: String
    let duration: Int
    let totalDuration: Int
    let notes: String
    let project: Project
    let task: Task
    let relations: [String]
}

struct Project: Codable {
    let id: Int
    let name: String
}

struct Task: Codable {
    let id: Int
    let name: String
}

struct MeResponse: Codable {
    let data: UserData
}

struct UserData: Codable {
    let me: User
}

struct User: Codable {
    let email: String
}
