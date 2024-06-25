//
//  ContentView.swift
//  BHappyWatch Watch App
//
//  Created by Gorkem Sevim on 23.06.2024.
//

import SwiftUI

struct MainScreen: View {
    @EnvironmentObject var appVm: AppVm
    let mainVm = MainScreenVm()
    
    var body: some View {
        VStack {
            Image("brew")
                .imageScale(.large)
            if mainVm.isLoading {
                ProgressView()
            } else {
                ForEach(mainVm.timers, id: \.id) { timer in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(timer.project.name)
                        Text(timer.task.name)
                        Text(timer.notes)
                    }
                }
            }
            Spacer()
            HStack {
                Button {
//                    Task {
//                    }
                } label: {
                    Image(systemName: "stop.fill")
                }
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .task {
            await mainVm.getTimers(token: appVm.token)
        }
    }
}

#Preview {
    MainScreen()
}
