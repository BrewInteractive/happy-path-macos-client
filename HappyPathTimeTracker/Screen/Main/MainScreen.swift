//
//  ContentView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 26.06.2023.
//

import SwiftUI
import SwiftDate
import Apollo
import DirectusGraphql

struct MainScreen: View {
    @StateObject private var mainScreenVm = MainScreenViewModel()
    @State private var selectedDate = Date()
    @State private var isNewEntryModalShown = false
    
    var dateList: [Date]
    
    init() {
        let firstDayOfWeek = Date().dateAtStartOf(.weekOfMonth)
        // create all of days for a week
        self.dateList = (0..<7).map({ index in
            firstDayOfWeek.dateByAdding(index, .day).date
        })
    }
    
    var body: some View {
        ZStack {
            Color("Background")
            RoundedRectangle(cornerRadius: 6)
                .stroke(.gray, lineWidth: 1)
            VStack(spacing: 4) {
                HeaderView(selectedDate: selectedDate)
                CircleDayListView(selectedDate: $selectedDate,
                                  dateList: dateList) { date in
                    selectedDate = date
                    mainScreenVm.fetch(date: date)
                }
                TimeDividier()
                TimeEntryListView(timeEntryList: mainScreenVm.timers, isLoading: $mainScreenVm.isLoading, onDelete: { id in
                    mainScreenVm.removeTimer(id: id, selectedDate: selectedDate)
                })
                    .frame(maxHeight: .infinity)
                TimeDividier()
                BottomView(isNewEntryModalShown: $isNewEntryModalShown)
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .frame(width: 360, height: 400)
        .onAppear {
            mainScreenVm.fetch(date: selectedDate)
        }
        .contextMenu {
            Button {
                mainScreenVm.refetch(date: selectedDate)
            } label: {
                Text("Yenile")
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

