//
//  TimeDividier.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 30.06.2023.
//

import SwiftUI

struct HappyDividier: View {
    var color: Color? = nil
    
    init(color: Color? = nil) {
        self.color = color
    }
    
    var body: some View {
        Divider()
            .frame(height: 1)
            .overlay(color ?? .ShadesofCadetGray.CadetGray300)
    }
}

struct TimeDividier_Previews: PreviewProvider {
    static var previews: some View {
        HappyDividier()
    }
}
