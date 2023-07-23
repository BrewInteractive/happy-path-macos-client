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
            VStack(spacing: 0) {
                if mainScreenVm.isLoading {
                    ProgressView()
                        .padding(.top, 20)
                } else if mainScreenVm.timers.isEmpty {
                    Text("No Entry")
                } else {
                    ForEach(Array(zip(mainScreenVm.timers.indices, mainScreenVm.timers)), id: \.0) { index, item in
                        if index != 0 && index != mainScreenVm.timers.count {
                            TimeDividier(color: .gray.opacity(0.1))
                        }
                        TimeEntryView(timeEntry: mainScreenVm.timers[index], activeTime: mainScreenVm.activeTimerSeconds, onStop: { id in
                            Task {
                                await mainScreenVm.stopTimer(for: id)
                            }
                        }, onEdit: { id in
                            mainScreenVm.showEditTimerModal(editedTimerId: id)
                        })
                            .onHover { isHovered in
                                if isHovered {
                                    hoveredTimeEntryId = mainScreenVm.timers[index].id
                                } else {
                                    hoveredTimeEntryId = nil
                                }
                            }
                            .background(content: {
                                hoveredTimeEntryId == mainScreenVm.timers[index].id ? Color.gray.opacity(0.2) : Color.clear
                            })
                            .contextMenu {
                                TimeEntryContextMenu(id: mainScreenVm.timers[index].id)
                            }
                    }
                }
            }
        }
        .padding(.vertical, 8)
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
            Button {
                print("view in site")
            } label: {
                Text("View in Beforesunset")
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
