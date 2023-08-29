//
//  CalendarView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 28.08.2023.
//

import Foundation
import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    var calendar: Calendar
//    private let monthDayFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekFormatter: DateFormatter
    
    @Binding var selectedDate: Date
    
    init(selectedDate: Binding<Date>) {
        self.calendar = Calendar.current
//        self.calendar.firstWeekday = 0
//        self.monthDayFormatter = DateFormatter(dateFormat: "MM/dd", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekFormatter = DateFormatter(dateFormat: "EEEEE", calendar: calendar)
        self._selectedDate = selectedDate
    }
    
    var body: some View {
        CalendarWeekListView(calendar: calendar,
                             date: $selectedDate) { date in
            CircleDayView(circleDay: .init(date: date, isSelected: isSameWith(date1: selectedDate, date2: date), totalSeconds: 0), dailyTotalDuration: mainScreenVm.getTotalDurationMinuteOfDayAsString(date: date))
                .onTapGesture {
                    mainScreenVm.updateMainScreenVmProp(for: \.selectedDate, newValue: date)
                    Task {
                        await mainScreenVm.getTimers(date: date)
                    }
                }
        }
                             .padding(.horizontal, 8)
                             .padding(.vertical, 14)
                             .background {
                                 Color.Primary.LightBabyPowder
                             }
    }
    func isSameWith(date1: Date, date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(selectedDate: .constant(.now))
            .environmentObject(MainScreenViewModel(networkSource: NetworkManager()))
    }
}
