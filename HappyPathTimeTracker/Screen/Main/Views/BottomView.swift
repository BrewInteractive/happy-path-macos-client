//
//  BottomView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

struct BottomView: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    @Binding var isNewEntryModalShown: Bool
    let selectedDate: Date
    
    init(isNewEntryModalShown: Binding<Bool>,
         selectedDate: Date) {
        self._isNewEntryModalShown = isNewEntryModalShown
        self.selectedDate = selectedDate
        print("render bottom view")
    }
    
    var body: some View {
        HStack {
            Button {
                if mainScreenVm.projects.count > 0 {
                    isNewEntryModalShown.toggle()
                } else {
                    print("no projects")
                }
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .buttonStyle(.plain)
            .popover(isPresented: $isNewEntryModalShown) {
                NewTimeEntryView(selectedDate: selectedDate, onCancel: {
                    isNewEntryModalShown = false
                }, onSuccess: {
                    isNewEntryModalShown = false
                })
            }
            Spacer()
            Button {
                mainScreenVm.refetch(date: selectedDate)
            } label: {
                Image(systemName: "arrow.clockwise")
                    .rotationEffect(mainScreenVm.isRefetching ? .degrees(360) : .degrees(0))
                               .animation(.easeIn, value: mainScreenVm.isRefetching)
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
        BottomView(isNewEntryModalShown: .constant(true), selectedDate: Date())
    }
}
