//
//  String.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 14.07.2023.
//

import Foundation

extension String {
    /// use to convert hour string style to minute to send db
    ///
    /// For example:
    ///
    /// 01:12 -> 72,
    ///
    /// :12 -> 12
    var toMinute: Int {
        if self.isEmpty {
            return 0
        }
        if self.contains(":") {
            let parts = self.split(separator: ":")
            if parts.count == 2 {
                return Int(parts[0])! * 60 + Int(parts[1])!
            } else if parts.count == 1 {
                return Int(parts[0])!
            }
        }
        
        return Int(self)!
    }
    
    var capitalizedFirstletter: Self {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst()
        return firstLetter + remainingLetters
    }
}
