//
//  CalendarWeekListView.swift
//  Habit
//
//  Created by Gorkem Sevim on 18.08.2023.
//

import Foundation
import SwiftUI
import SwiftDate

struct CalendarWeekListView<Day: View>: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    private var calendar: Calendar
    @Binding var date: Date
    private let content: (Date) -> Day
    
    init(calendar: Calendar,
         date: Binding<Date>,
         @ViewBuilder content: @escaping (Date) -> Day) {
        self.calendar = calendar
        self._date = date
        self.content = content
    }
    
    var body: some View {
        let days = makeDays()
        
        return VStack {
            HStack(spacing: 10) {
                Image("chevron-left")
                    .resizable()
                    .foregroundColor(Color.Primary.CadetGray)
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        if mainScreenVm.previousMonthLastWeekStartDate.isBeforeDate(date, orEqual: true, granularity: .day) {
                            let tmpSelectedDate = date.dateByAdding(-1, .day)
                            mainScreenVm.updateMainScreenVmProp(for: \.selectedDate, newValue: tmpSelectedDate.date)
                            Task {
                                await mainScreenVm.getTimers(date: tmpSelectedDate.date)
                            }
                        }
                    }
                ForEach(Array(zip(days.indices, days)), id: \.0) { index, day in
                    content(DateInRegion(day, region: .local).date)
                }
                Image("chevron-right")
                    .resizable()
                    .foregroundColor(Color.Primary.CadetGray)
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        let tmpSelectedDate = date.dateByAdding(1, .day)
                        mainScreenVm.updateMainScreenVmProp(for: \.selectedDate, newValue: tmpSelectedDate.date)
                        Task {
                            await mainScreenVm.getTimers(date: tmpSelectedDate.date)
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

//MARK: - Helper
private extension CalendarWeekListView {
    func makeDays() -> [Date] {
        guard let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: date),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: firstWeek.end - 1) else {
            return []
        }
        let dateInterval = DateInterval(start: firstWeek.start, end: lastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
}

private extension Calendar {
    func generateDays(for dateInterval: DateInterval,
                      matching components: DateComponents) -> [Date] {
        var dates = [dateInterval.start]
        enumerateDates(startingAfter: dateInterval.start,
                       matching: components,
                       matchingPolicy: .nextTime) { date, exactMatch, stop in
            guard let date = date else {
                return
            }
            
            guard date < dateInterval.end else {
                stop = true
                return
            }
            
            dates.append(date)
        }
        
        return dates
    }
    
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDays(for: dateInterval, matching: dateComponents([.hour, .minute, .second], from: dateInterval.start))
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self)) ?? self
    }
}

extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
}
