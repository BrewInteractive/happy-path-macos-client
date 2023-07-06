//
//  CircleDayListView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

struct CircleDayListView: View {
    @Binding var selectedDate: Date
    let dateList: [Date]
    let onDateSelect: ((_ date: Date) -> Void)
    
    var body: some View {
        HStack {
            Image(systemName: "lessthan")
                .resizable()
                .fontWeight(.heavy)
                .frame(width: 4, height: 8)
                .onTapGesture {
                    let tmpSelectedDate = selectedDate.dateByAdding(-1, .day)
                    if(tmpSelectedDate.date.isAfterDate(dateList[0], orEqual: true, granularity: .day)) {
                        onDateSelect(tmpSelectedDate.date)
                    }
                }
            Spacer()
            ForEach(dateList, id: \.self) { date in
                CircleDayView(date: .init(date: date,
                                          isSelected: date.compare(toDate: selectedDate, granularity: .day).rawValue == 0, totalSeconds: 0))
                .contentShape(Rectangle())
                .onTapGesture {
                    onDateSelect(date)
                }
                Spacer()
            }
            Image(systemName: "greaterthan")
                .resizable()
                .fontWeight(.heavy)
                .frame(width: 4, height: 8)
                .onTapGesture {
                    let tmpSelectedDate = selectedDate.dateByAdding(1, .day)
                    if(tmpSelectedDate.date.isBeforeDate(dateList.last!, orEqual: true, granularity: .day)) {
                        onDateSelect(tmpSelectedDate.date)
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 8)
    }
}

struct CircleDayListView_Previews: PreviewProvider {
    static var previews: some View {
        CircleDayListView(selectedDate: .constant(Date()),
                          dateList: [Date()], onDateSelect: { date in
            print("date: ", date)
        })
    }
}
