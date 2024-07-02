//
//  Github.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 2.07.2024.
//

import Foundation

struct Github: Codable {
    let tagName: String

    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
    }
}
