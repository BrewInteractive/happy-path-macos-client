//
//  TimeDividier.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 30.06.2023.
//

import SwiftUI

struct TimeDividier: View {
    var color: Color? = nil
    
    init(color: Color? = nil) {
        self.color = color
    }
    
    var body: some View {
        Divider()
            .frame(height: 1)
            .overlay(color ?? .gray.opacity(0.8))
    }
}

struct TimeDividier_Previews: PreviewProvider {
    static var previews: some View {
        TimeDividier()
    }
}
