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
        
        print("render main screen")
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
                    mainScreenVm.getTimers(date: date)
                }
                TimeDividier()
                TimeEntryListView(selectedDate: selectedDate)
                    .frame(maxHeight: .infinity)
                    .environmentObject(mainScreenVm)
                TimeDividier()
                BottomView(isNewEntryModalShown: $isNewEntryModalShown, selectedDate: selectedDate)
                .environmentObject(mainScreenVm)
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .frame(width: 360, height: 400)
        .onAppear {
            mainScreenVm.getTimers(date: selectedDate)
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

