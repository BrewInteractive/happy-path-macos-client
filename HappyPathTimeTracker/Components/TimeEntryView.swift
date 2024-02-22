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
    let isHovered: Bool
    let onStop: ((Int) async -> Void)
    let onEdit: ((Int) async -> Void)
    let onRestart: ((Int) async -> Void)
    let onDelete: ((Int) async -> Void)
    
    var isActive: Bool {
        return timeEntry.endsAt == nil ||
        (timeEntry.endsAt != nil && timeEntry.endsAt!.isEmpty)
    }
    
    var activeTimeMinute: String {
//        if let startedDate = timeEntry.startsAt, let date = timeEntry.startsAt?.toISODate()?.date {
//            let now = Date.now
//            let diffM =  now.difference(in: .minute, from: date) ?? 0
//            let diffH =  now.difference(in: .hour, from: date) ?? 0
//            let durationH = (timeEntry.duration ?? 0) / 60
//            let durationM = (timeEntry.duration ?? 0) - durationH * 60
//            let totalH = diffH + durationH
//            let totalM = diffM + durationM
//            let h = String(format: "%02d", totalH)
//            let m = String(format: "%02d", totalM)
//            return "\(h):\(m)"
//        }
        
        let totalDurationH = timeEntry.totalDuration / 60
        let totalDurationM = timeEntry.totalDuration - (60 * totalDurationH)
        
        let h = String(format: "%02d", totalDurationH)
        let m = String(format: "%02d", totalDurationM)
        return "\(h):\(m)"
    }
    
    var showRestartButton: Bool {
        return timeEntry.startsAt != nil && (timeEntry.startsAt!.toISODate()?.date.isToday ?? false)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(timeEntry.taskName)
                    .font(.figtree(size: 14, weight: .medium))
                    .foregroundColor(.Primary.DarkNight)
//                    .background {
//                        tasksBackground[timeEntry.taskId] ?? Color.ShadesOfIcterine.Icterine100
//                    }
                if !timeEntry.notes.isEmpty {
                    Text(timeEntry.notes)
                        .font(.figtree(size: 12))
                        .foregroundColor(.G.G_959595)
                        .lineLimit(2)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(isActive ? "\(activeTimeMinute)" : "\(timeEntry.totalDuration.minuteToHours)")
                    .font(.figtree(size: 14, weight: .bold))
                    .foregroundColor(isActive ? .ShadesofCadetGray.CadetGray500 : .ShadesofCadetGray.CadetGray900)
                HStack(spacing: 8) {
                    Button {
                        Task {
                            await onDelete(timeEntry.id)
                        }
                    } label: {
                        RoundedButton(image: Image(systemName: "trash"), color:  Color.red)
                    }
                    .buttonStyle(.plain)
                    Button {
                        Task {
                            await onEdit(timeEntry.id)
                        }
                    } label: {
                        RoundedButton(image: Image(systemName: "pencil"), color:  Color.ShadesOfTeal.Teal_400)
                    }
                    .buttonStyle(.plain)
                    
                    if isActive {
                        Button {
                            Task {
                                await onStop(timeEntry.id)
                            }
                        } label: {
                            RoundedButton(image: Image("Pause Icon"), color: Color.ShadesOfCoral.Coral500)
                        }
                        .buttonStyle(.plain)
                    } else if(showRestartButton) {
                        Button {
                            Task {
                                await onRestart(timeEntry.id)
                            }
                        } label: {
                            RoundedButton(image: Image(systemName: "play.fill"), color:  Color.ShadesOfTeal.Teal_400)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.top, 4)
        }
        .padding(.bottom, 16)
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
                                       totalDuration: 123), isHovered: true) { id in
            print("start")
        } onEdit: { id in
            print("edit")
        } onRestart: { id in
            print("restart")
        } onDelete: { id in
            print("delete")
        }
        .background {
            Color.ShadesofCadetGray.CadetGray100
        }
    }
}

struct RoundedButton: View {
    let image: Image
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:100)
                .fill(Color.ShadesOfDark.D_04)
                .frame(width: 32, height: 32)
            image
                .resizable()
                .foregroundColor(color)
                .frame(width: 12, height: 12)
        }
    }
}
