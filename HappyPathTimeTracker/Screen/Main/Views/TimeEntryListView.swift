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
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 8) {
                if mainScreenVm.timers.isEmpty {
                    NoEntryView()
                        .environmentObject(mainScreenVm)
                } else {
                    ForEach(mainScreenVm.groupedTimers.sorted(by: { $0.key < $1.key }), id: \.key) { (projectId, entries) in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(entries.first?.projectName ?? "")
                                .font(.figtree(size: 16, weight: .bold))
                                .foregroundColor(.Primary.DarkNight)
                                .padding(.horizontal, 12)
                            ForEach(entries, id: \.id) { entry in
                                TimeEntryView(timeEntry: entry,
                                              isHovered: hoveredTimeEntryId == entry.id,
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
                                }, onDelete: { id in
                                    Task {
                                        await mainScreenVm.removeTimer(id: id, selectedDate: selectedDate)
                                    }
                                })
                                .onTapGesture(count: 2, perform: {
                                    mainScreenVm.showEditTimerModal(editedTimerId: entry.id)
                                })
                                .onHover { isHovered in
                                    if isHovered {
                                        hoveredTimeEntryId = entry.id
                                    } else {
                                        hoveredTimeEntryId = nil
                                    }
                                }
                                .padding(.horizontal, 12)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(hoveredTimeEntryId == entry.id ? Color.G.G_DBDFE1 : Color.G.G_F3F6F7)
                                })
                            }
                        }
                        .padding(.top, 8)
//                        .padding(.horizontal, 12)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color.G.G_F3F6F7)
                        }
                        .padding(16)
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
            .environmentObject(MainScreenViewModel(networkSource: NetworkManager()))
    }
}
