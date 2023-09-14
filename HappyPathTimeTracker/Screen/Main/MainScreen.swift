//
//  ContentView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 26.06.2023.
//

import SwiftUI
import Apollo
import DirectusGraphql
import PopupView

struct MainScreen: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var mainScreenVm = MainScreenViewModel(networkSource: NetworkManager())
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ZStack {
            Color.Primary.RealWhite
            RoundedRectangle(cornerRadius: 6)
                .stroke(.gray, lineWidth: 1)
            if appState.isLoggedIn {
                VStack(spacing: 0) {
                    HeaderView()
                        .environmentObject(mainScreenVm)
                    CalendarView(selectedDate: $mainScreenVm.selectedDate)
                        .environmentObject(mainScreenVm)
                    HappyDividier()
                    ZStack {
                        TimeEntryListView(selectedDate: mainScreenVm.selectedDate)
                            .environmentObject(mainScreenVm)
                        if mainScreenVm.isLoading {
                            ZStack {
                                Color.Primary.DarkNight.opacity(0.2)
                                ProgressView()
                                    .background {
                                        Color.ShadesOfDark.D_04.opacity(0.3)
                                    }
                            }
                        }
                    }
                    HappyDividier()
                    BottomView(selectedDate: mainScreenVm.selectedDate)
                        .environmentObject(mainScreenVm)
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .onAppear {
                    Task {
                        await mainScreenVm.updateViewModel(appState: appState)
                    }
                }
                .popup(isPresented: $mainScreenVm.isErrorShown) {
                    Text("Error occured")
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                } customize: {
                    $0
                        .autohideIn(2)
                        .type(.floater(verticalPadding: 8, horizontalPadding: 8, useSafeAreaInset: true))
                        .position(.bottomTrailing)
                        .appearFrom(.bottom)
                        .dismissCallback {
                            mainScreenVm.updateMainScreenVmProp(for: \.isErrorShown, newValue: false)
                        }
                        .animation(.spring())
                }
            } else {
               LoginScreen()
            }
        }
        .contextMenu {
            VStack {
                if appState.isLoggedIn {                
                    Button {
                        Task {
                            await mainScreenVm.refetch(date: mainScreenVm.selectedDate)
                        }
                    } label: {
                        Text("Yenile")
                    }
                }
                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Text("Kapat")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .environmentObject(AppState())
    }
}

