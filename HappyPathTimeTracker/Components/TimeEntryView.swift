//
//  TimeEntryView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

struct TimeEntryView: View {
    let timeEntry: TimeEntry
    let activeTime: Double
    let onStop: ((Int) -> Void)
    let onEdit: ((Int) -> Void)
    
    var isActive: Bool {
        return timeEntry.endsAt == nil ||
        (timeEntry.endsAt != nil && timeEntry.endsAt!.isEmpty)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(timeEntry.projectName)
                            .font(.footnote)
                            .foregroundColor(.gray.opacity(0.8))
                        Text(timeEntry.taskName)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                        Text(timeEntry.notes)
                            .font(.callout)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    HStack {
                        if isActive {
                            Button {
                                onStop(timeEntry.id)
                            } label: {
                                Image("stop")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                            }
                            .buttonStyle(.plain)
                        }
                        Button {
                            onEdit(timeEntry.id)
                        } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.plain)
                        Text(isActive ? "\(Int(activeTime).toHours)" : "\(timeEntry.totalDuration.minuteToHours)")
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }
        }
    }
}

struct TimeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TimeEntryView(timeEntry: .init(id: 1,
                                       projectId: 2,
                                       projectName: "name",
                                       taskId: 3,
                                       taskName: "name",
                                       notes: "notes",
                                       startsAt: "",
                                       endsAt: "",
                                       duration: 0,
                                       totalDuration: 123), activeTime: 1) { id in
            print("start")
        } onEdit: { id in
            print("edit")
        }
    }
}
