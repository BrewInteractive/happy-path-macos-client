//
//  TimeEntryView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

let tasksBackground: [Int:Color] = [
    1: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
    2: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
    3: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
    5: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
    6: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
    9: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
    10: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
    39: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
    40: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
    59: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
    60: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
    135: Color.ShadesOfNonPhotoBlue.NonPhotoBlue300,
]

struct TimeEntryView: View {
    let timeEntry: TimeEntry
    let activeTime: Double
    let activeTimerId: Int?
    let onStop: ((Int) async -> Void)
    let onEdit: ((Int) async -> Void)
    let onRestart: ((Int) async -> Void)
    
    var isActive: Bool {
        return timeEntry.endsAt == nil ||
        (timeEntry.endsAt != nil && timeEntry.endsAt!.isEmpty)
    }
    
    var showRestartButton: Bool {
        return activeTimerId == nil && timeEntry.startsAt != nil && (timeEntry.startsAt!.toISODate()?.date.isToday ?? false)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(timeEntry.projectName)
                        .font(.figtree(size: 16))
                        .foregroundColor(.Primary.DarkNight)
                    Text(timeEntry.taskName)
                        .foregroundColor(.Primary.DarkNight)
                        .padding(4)
                        .background {
                            tasksBackground[timeEntry.taskId] ?? Color.ShadesOfIcterine.Icterine100
                        }
                    if !timeEntry.notes.isEmpty {
                        Text(timeEntry.notes)
                            .font(.callout)
                            .foregroundColor(.ShadesofCadetGray.CadetGray900)
                    }
                }
                Spacer()
                HStack {
                    Text(isActive ? "\(Int(activeTime).toHours)" : "\(timeEntry.totalDuration.minuteToHours)")
                        .foregroundColor(isActive ? .ShadesofCadetGray.CadetGray500 : .ShadesofCadetGray.CadetGray900)
                        .onTapGesture {
                            Task {
                                await onEdit(timeEntry.id)
                            }
                        }
                    if isActive {
                        Button {
                            Task {
                                await onStop(timeEntry.id)
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius:100)
                                    .fill(Color.Primary.RealWhite)
                                    .frame(width: 32, height: 32)
                                Image("Pause Icon")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.ShadesOfCoral.Coral500)
                            }
                        }
                        .buttonStyle(.plain)
                    } else if(showRestartButton) {
                        Button {
                            Task {
                                await onRestart(timeEntry.id)
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius:100)
                                    .fill(Color.ShadesOfDark.D_04)
                                    .frame(width: 32, height: 32)
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .foregroundColor(.ShadesOfTeal.Teal_400)
                                    .frame(width: 12, height: 12)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
        }
    }
}

struct TimeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TimeEntryView(timeEntry: .init(id: 1,
                                       projectId: 2,
                                       projectName: "name",
                                       taskId: 39,
                                       taskName: "task name",
                                       notes: "notes",
                                       startsAt: Date().toISO(),
                                       endsAt: nil,
                                       duration: 0,
                                       totalDuration: 123), activeTime: 1, activeTimerId: nil) { id in
            print("start")
        } onEdit: { id in
            print("edit")
        } onRestart: { id in
            print("restart")
        }
        .background {
            Color.ShadesofCadetGray.CadetGray100
        }
    }
}
