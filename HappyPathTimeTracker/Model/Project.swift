//
//  Project.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 8.07.2023.
//

import Foundation

struct Project: Identifiable, Hashable {
    typealias ID = Int
    let id: Int
    var name: String
}
