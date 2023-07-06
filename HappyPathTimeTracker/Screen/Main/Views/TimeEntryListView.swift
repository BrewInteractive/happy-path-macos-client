//
//  TimeEntryListView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

struct TimeEntryListView: View {
    let timeEntryList: [TimeEntry]
    @Binding var isLoading: Bool
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                if isLoading {
                    ProgressView()
                        .padding(.top, 20)
                } else if timeEntryList.isEmpty {
                    Text("No Entry")
                } else {
                    //TODO: indices yerine remove ve add durumlarindan etkilenmeyecek bir prop kullanilmali
                    ForEach(timeEntryList.indices) { index in
                        if index != 0 && index != timeEntryList.count {
                            TimeDividier(color: .gray.opacity(0.1))
                        }
                        TimeEntryView(timeEntry: timeEntryList[index])
                            .contextMenu {
                                TimeEntryContextMenu()
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
    func TimeEntryContextMenu() -> some View {
        VStack {
            Button {
                print("edit")
            } label: {
                Text("Edit Entry")
            }
            Button {
                print("start")
            } label: {
                Text("Start Timer")
            }
            Button {
                print("delete")
            } label: {
                Text("Delete Entry")
            }
            Button {
                print("view in beforesunset")
            } label: {
                Text("View in Beforesunset")
            }
        }
    }
}

struct PersistedTimeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TimeEntryListView(timeEntryList: [
            .init(id: 1,
                  projectId: 1,
                  projectName: "Example Project",
                  taskId: 1,
                  taskName: "Frontend Development",
                  notes: "Dummy Notes",
                  elapsedTime: 12312312),
            .init(id: 2,
                  projectId: 1,
                  projectName: "Example Project",
                  taskId: 1,
                  taskName: "Frontend Development",
                  notes: "Dummy Notes",
                  elapsedTime: 12312312)
        ], isLoading: .constant(true))
    }
}
