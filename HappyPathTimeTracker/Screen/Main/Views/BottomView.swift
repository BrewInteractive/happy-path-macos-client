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
    
    var body: some View {
        HStack {
            Button {
                if mainScreenVm.projects.count > 0 {
                    mainScreenVm.showNewEntryTimerModal()
                } else {
                    print("no projects")
                }
            } label: {
                ZStack {
                    Color.white.opacity(0.00001)
                        .frame(width: 24, height: 24)
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 14, height: 14)
                }
            }
            .buttonStyle(.plain)
            .popover(isPresented: $mainScreenVm.isNewEntryModalShown) {
                NewTimeEntryView(selectedDate: selectedDate)
                    .environmentObject(mainScreenVm)
            }
            Spacer()
            Button {
                Task {
                    await mainScreenVm.refetch(date: selectedDate)
                }
            } label: {
                ZStack {
                    Color.white.opacity(0.00001)
                        .frame(width: 24, height: 24)
                    Image(systemName: "arrow.clockwise")
                }
            }
            .buttonStyle(.plain)
            .padding(.trailing, 8)
            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                ZStack {
                    Color.white.opacity(0.00001)
                        .frame(width: 24, height: 24)
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 14, height: 14)
                }
            }
            .buttonStyle(.plain)
            .padding(.trailing, 8)
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
    }
}
