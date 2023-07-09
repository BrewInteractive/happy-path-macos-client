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
    @EnvironmentObject var appState: AppState
    @StateObject private var mainScreenVm = MainScreenViewModel()
    @State private var selectedDate = Date()
    @State private var isNewEntryModalShown = false
    @Environment(\.openURL) var openURL
    
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
            if appState.isLoggedIn {
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
                .onAppear {
                    mainScreenVm.updateViewModel(appState: appState)
                    mainScreenVm.getTimers(date: selectedDate)
                }
            } else {
                Button {
                    openURL(URL(string: "http://localhost:8080/login?callback=happytime://action-name")!)
                } label: {
                    Text("Please Login")
                }

            }
        }
        .frame(width: 360, height: 400)
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

