//
//  BottomView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

struct BottomView: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    let selectedDate: Date
    @State private var isShown = false
    
    var body: some View {
        HStack {
            if mainScreenVm.previousMonthLastWeekStartDate.isBeforeDate(selectedDate, orEqual: true, granularity: .day) {
                Button {
                    if mainScreenVm.projects.count > 0 {
                        mainScreenVm.showNewEntryTimerModal()
                    } else {
                        Task {
                            await mainScreenVm.refetch(date: selectedDate)
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius:100)
                            .fill(Color.ShadesOfDark.D_04)
                            .frame(width: 32, height: 32)
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(.ShadesOfTeal.Teal_400)
                            .frame(width: 14, height: 14)
                    }
                }
                .buttonStyle(.plain)
                .sync($mainScreenVm.isNewEntryModalShown, with: $isShown)
            }
            Spacer()
            Button {
                Task {
                    await mainScreenVm.refetch(date: selectedDate)
                }
            } label: {
                ZStack {
                    ZStack {
                        RoundedRectangle(cornerRadius:100)
                            .fill(Color.ShadesOfDark.D_04)
                            .frame(width: 32, height: 32)
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .foregroundColor(.ShadesOfTeal.Teal_400)
                            .frame(width: 12, height: 14)
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(.trailing, 8)
//            Button {
//                mainScreenVm.logout()
//            } label: {
//                ZStack {
//                    RoundedRectangle(cornerRadius:100)
//                        .fill(Color.ShadesOfDark.D_04)
//                        .frame(width: 32, height: 32)
//                    Image("log-out")
//                        .resizable()
//                        .foregroundColor(.ShadesOfTeal.Teal_400)
//                        .frame(width: 14, height: 14)
//                }
//            }
//            .buttonStyle(.plain)
//            .padding(.trailing, 8)//TODO: add logout button
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 8)
        .padding(.top, 4)
        .padding(.leading, 6)
    }
}

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        BottomView(selectedDate: Date())
            .environmentObject(MainScreenViewModel(networkSource: NetworkManager()))
    }
}
