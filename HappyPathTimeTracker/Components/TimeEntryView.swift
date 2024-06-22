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

let RELATED_LINKS_LIMIT = 2

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
                    .padding(.top, 4)
                if !timeEntry.notes.isEmpty {
                    Text(timeEntry.notes)
                        .font(.figtree(size: 12))
                        .foregroundColor(.G.G_959595)
                        .lineLimit(2)
                }
                if timeEntry.relations != nil {
                    ForEach(timeEntry.relations!.prefix(RELATED_LINKS_LIMIT).indices, id: \.self) { index in
                        HStack(spacing: 2) {
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: 4, height: 4)
                            Link(timeEntry.relations![index].lowercased(), destination: URL(string: timeEntry.relations![index])!)
                            if index == RELATED_LINKS_LIMIT - 1 {
                                Text("...")
                                    .foregroundStyle(Color.ShadesOfTeal.Teal_400)
                            }
                        }
                    }
                }
                Spacer()
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
                        RoundedButton(image: Image(systemName: "trash.circle.fill"), color:  Color.red)
                    }
                    .buttonStyle(.plain)
                    Button {
                        Task {
                            await onEdit(timeEntry.id)
                        }
                    } label: {
                        RoundedButton(image: Image(systemName: "square.and.pencil.circle.fill"), color:  Color.ShadesOfTeal.Teal_400)
                    }
                    .buttonStyle(.plain)
                    
                    if isActive {
                        Button {
                            Task {
                                await onStop(timeEntry.id)
                            }
                        } label: {
                            RoundedButton(image: Image(systemName: "pause.circle.fill"), color: Color.ShadesOfCoral.Coral500)
                        }
                        .buttonStyle(.plain)
                    } else if(showRestartButton) {
                        Button {
                            Task {
                                await onRestart(timeEntry.id)
                            }
                        } label: {
                            RoundedButton(image: Image(systemName: "play.circle.fill"), color:  Color.ShadesOfTeal.Teal_400)
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
                                       relations: nil,
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
//        ZStack {
//            RoundedRectangle(cornerRadius:100)
//                .fill(Color.ShadesOfDark.D_04)
//                .frame(width: 32, height: 32)
//            
//        }
        image
            .resizable()
            .foregroundColor(color)
            .frame(width: 24, height: 24)
    }
}
