//
//  TimeEntryView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import Foundation
import SwiftUI

struct TimeEntryView: View {
    let timeEntry: TimeEntry
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
            VStack(alignment: .leading) {
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
                        Text("\(timeEntry.totalDuration)")
                        Image(systemName: "play.circle")
                    }
                }
                .padding(8)
            }
        }
    }
}

struct TimeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TimeEntryView(timeEntry: .init(id: 1,
                                       projectId: 1,
                                       projectName: "Example Project",
                                       taskId: 1,
                                       taskName: "Frontend Development",
                                       notes: "Dummy Notes",
                                       startsAt: "",
                                       endsAt: "",
                                       totalDuration: 12312312))
    }
}
