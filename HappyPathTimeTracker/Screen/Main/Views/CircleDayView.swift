//
//  CircleDayView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

struct CircleDayView: View {
    var date: CircleDay
    
    var body: some View {
        VStack {
            Circle()
                .frame(width: 32)
                .foregroundColor(date.isSelected ? Color("SelectedDate") : .gray)
                .opacity(date.isSelected ? 1.0 : 0.0)
                .overlay {
                    Text("\(date.date.weekdayName(.veryShort))")
                        .fontWeight(date.isSelected ? .bold : .regular)
                }
            Text("0:00")
                .font(.caption)
        }
    }
}

struct CircleDayView_Previews: PreviewProvider {
    static var previews: some View {
        CircleDayView(date: .init(date: Date(),
                                  isSelected: true,
                                  totalSeconds: 123))
    }
}
