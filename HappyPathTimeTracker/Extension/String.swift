//
//  String.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 14.07.2023.
//

import Foundation

extension String {
    var toMinute: Int {
        if self.isEmpty {
            return 0
        }
        if self.contains(":") {
            let parts = self.split(separator: ":")
            
            return Int(parts[0])! * 60 + Int(parts[1])!
        }
        
        return Int(self)!
    }
}
