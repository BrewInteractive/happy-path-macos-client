//
//  CircleDayView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

struct CircleDayView: View {
    var date: CircleDay
    var dailyTotalDuration: String = "00:00"
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 32)
                    .foregroundColor(date.isSelected ? .ShadesOfTeal.Teal_400 : .ShadesOfLightWhite.W_88)
                VStack {
                    Text("\(date.date.weekdayName(.veryShort))")
                        .foregroundColor(date.isSelected ? .ShadesOfLightWhite.W_64 : .Primary.CadetGray)
                }
            }
            Text(dailyTotalDuration)
                .foregroundColor(dailyTotalDuration == "00:00" ? .ShadesofCadetGray.CadetGray500 : .ShadesofCadetGray.CadetGray900)
        }
    }
}

struct CircleDayView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CircleDayView(date: .init(date: Date(),
                                      isSelected: true,
                                      totalSeconds: 123),
                          dailyTotalDuration: "00:12")
            CircleDayView(date: .init(date: Date(),
                                      isSelected: false,
                                      totalSeconds: 123),
                          dailyTotalDuration: "00:12")
            CircleDayView(date: .init(date: Date(),
                                      isSelected: false,
                                      totalSeconds: 123),
                          dailyTotalDuration: "00:00")
        }
        .background {
            Color.Primary.LightBabyPowder
        }
    }
    
}
