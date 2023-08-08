//
//  TimeEntryListView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

struct TimeEntryListView: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    @State private var hoveredTimeEntryId: Int? = nil
    let selectedDate: Date
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 3) {
                if mainScreenVm.timers.isEmpty {
                    NoEntryView()
                        .environmentObject(mainScreenVm)
                        .frame(maxHeight: .infinity)
                } else {
                    ForEach(Array(zip(mainScreenVm.timers.indices, mainScreenVm.timers)), id: \.0) { index, item in
                        if index != 0 && index != mainScreenVm.timers.count {
                            HappyDividier(color: .gray.opacity(0.1))
                        }
                        TimeEntryView(timeEntry: mainScreenVm.timers[index],
                                      activeTime: mainScreenVm.activeTimerSeconds,
                                      activeTimerId: mainScreenVm.activeTimerId,
                                      onStop: { id in
                            Task {
                                await mainScreenVm.stopTimer(for: id)
                            }
                        }, onEdit: { id in
                            mainScreenVm.showEditTimerModal(editedTimerId: id)
                        }, onRestart: { id in
                            Task {
                                await mainScreenVm.restartTimer(for: id)
                            }
                        })
                        .onHover { isHovered in
                            if isHovered {
                                hoveredTimeEntryId = mainScreenVm.timers[index].id
                            } else {
                                hoveredTimeEntryId = nil
                            }
                        }
                        .background(content: {
                            hoveredTimeEntryId == mainScreenVm.timers[index].id ? Color.ShadesOfTeal.Teal_100 : Color.ShadesofCadetGray.CadetGray50
                        })
                        .contextMenu {
                            TimeEntryContextMenu(id: mainScreenVm.timers[index].id)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension TimeEntryListView {
    @ViewBuilder
    func TimeEntryContextMenu(id: Int) -> some View {
        VStack {
            Button {
                mainScreenVm.showEditTimerModal(editedTimerId: id)
            } label: {
                Text("Edit Entry")
            }
            Button {
                Task {
                    await mainScreenVm.removeTimer(id: id, selectedDate: selectedDate)
                }
            } label: {
                Text("Delete Entry")
            }
        }
    }
}

struct PersistedTimeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TimeEntryListView(selectedDate: Date())
            .environmentObject(MainScreenViewModel())
    }
}
