//
//  CircleDayListView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

struct CircleDayListView: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    @Binding var selectedDate: Date
    let dateList: [Date]
    
    var body: some View {
        HStack {
            Image("chevron-left")
                .resizable()
                .foregroundColor(Color.Primary.CadetGray)
                .frame(width: 20, height: 20)
                .onTapGesture {
                    let tmpSelectedDate = selectedDate.dateByAdding(-1, .day)
                    if(tmpSelectedDate.date.isAfterDate(dateList[0], orEqual: true, granularity: .day)) {
                        mainScreenVm.updateMainScreenVmProp(for: \.selectedDate, newValue: tmpSelectedDate.date)
                        Task {
                            await mainScreenVm.getTimers(date: tmpSelectedDate.date)
                        }
                    }
                }
            Spacer()
            ForEach(dateList, id: \.self) { date in
                CircleDayView(date: .init(date: date,
                                          isSelected: date.compare(toDate: selectedDate, granularity: .day).rawValue == 0,
                                          totalSeconds: 0),
                              dailyTotalDuration: mainScreenVm.getTotalDurationMinuteOfDayAsString(date: date.startOfDayISO))
                .onTapGesture {
                    mainScreenVm.updateMainScreenVmProp(for: \.selectedDate, newValue: date)
                    Task {
                        await mainScreenVm.getTimers(date: date)
                    }
                }
                Spacer()
            }
            Image("chevron-right")
                .resizable()
                .foregroundColor(Color.Primary.CadetGray)
                .frame(width: 20, height: 20)
                .onTapGesture {
                    let tmpSelectedDate = selectedDate.dateByAdding(1, .day)
                    if(tmpSelectedDate.date.isBeforeDate(dateList.last!, orEqual: true, granularity: .day)) {
                        mainScreenVm.updateMainScreenVmProp(for: \.selectedDate, newValue: tmpSelectedDate.date)
                        Task {
                            await mainScreenVm.getTimers(date: tmpSelectedDate.date)
                        }
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 8)
        .padding(.vertical, 14)
        .background {
            Color.Primary.LightBabyPowder
        }
    }
}

struct CircleDayListView_Previews: PreviewProvider {
    static var previews: some View {
        CircleDayListView(selectedDate: .constant(Date()),
                          dateList: [Date(), Date(), Date(), Date(), Date(), Date(), Date()])
        .environmentObject(MainScreenViewModel(networkSource: NetworkManager()))
    }
}
