//
//  Int.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 14.07.2023.
//

import Foundation

extension Int {
    var toHours: String {
        let hours = self / 3600
        let minute = (self - hours * 3600) / 60
        let seconds = self - hours * 3600 - minute * 60
        
        return "\(String(format: "%02d", hours)):\(String(format: "%02d", minute)):\(String(format: "%02d", seconds))"
    }
    
    var minuteToHours: String {
        let hours = self / 60
        let minute = (self - hours * 60)
        
        return "\(String(format: "%02d", hours)):\(String(format: "%02d", minute))"
    }
}

extension Optional<Int> {
    var minuteToHours: String {
        if self == nil {
            return "00:00"
        }
        let hours = self! / 60
        let minute = (self! - hours * 60)
        
        return "\(String(format: "%02d", hours)):\(String(format: "%02d", minute))"
    }
}
