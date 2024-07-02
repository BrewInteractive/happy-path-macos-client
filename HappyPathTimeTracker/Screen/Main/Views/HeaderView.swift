//
//  HeaderView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI
import Combine
import AppKit

struct HeaderView: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    @State private var isInfoShown = false
    @State private var isErrorInfoShown = false
    @State private var isFlashing = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.ShadesOfTeal.Teal_400)
                .frame(height:36)
            HStack {
                Text("\(mainScreenVm.selectedDate.toFormat("EEEE, dd MMM"))")
                    .font(.figtree(weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(mainScreenVm.isUpdateInfoShown ? Color.Primary.Cavendish : .Primary.RealWhite)
                    .fontWeight(.bold)
                    .popover(isPresented: $isInfoShown, content: {
                        InfoView()
                    })
                    .onTapGesture {
                        isInfoShown.toggle()
                    }
            }
            .padding(.horizontal, 8)
        }
    }
}

extension HeaderView {
    @ViewBuilder
    func InfoView() -> some View {
        VStack(spacing: 12) {
            if !mainScreenVm.email.isEmpty {
                Text(mainScreenVm.email)
                    .foregroundColor(.Primary.DarkNight)
            }
            Text("Time Summary")
                .foregroundColor(.Primary.DarkNight)
            Divider()
                .frame(height: 1)
                .foregroundColor(.accentColor)
            Grid() {
                GridRow {
                    VStack {
                        Text("Hours Today")
                        Text("0")
                    }
                    .foregroundColor(.Primary.DarkNight)
                    Rectangle()
                        .fill(Color.ShadesOfTeal.Teal_400.opacity(0.2))
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)
                    VStack {
                        Text("Hours Yesterday")
                        Text("Will be added")
                    }
                    .foregroundColor(.Primary.DarkNight)
                }
                Rectangle()
                    .fill(Color.ShadesOfTeal.Teal_400.opacity(0.2))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                GridRow {
                    VStack {
                        Text("Hours This Week")
                            .foregroundColor(.Primary.DarkNight)
                        Text("0")
                    }
                    .foregroundColor(.Primary.DarkNight)
                    Rectangle()
                        .fill(Color.ShadesOfTeal.Teal_400.opacity(0.2))
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)
                    VStack {
                        Text("Hours This Month")
                        Text("0")
                    }
                    .foregroundColor(.Primary.DarkNight)
                }
            }
            Divider()
                .frame(height: 1)
                .foregroundColor(.accentColor)
            HStack() {
                Button(action: {
                    print("send email")
                }, label: {
                    Image(systemName: "envelope")
                        .resizable()
                        .frame(width: 16, height: 12)
                        .foregroundStyle(Color.ShadesOfTeal.Teal_400)
                })
                .buttonStyle(.plain)
                Spacer()
                HStack {
                    Text("Version: \(Bundle.main.appVersion)")
                        .font(.figtree(size: 12))
                        .foregroundColor(.Primary.DarkNight)
                    if mainScreenVm.isUpdateInfoShown {
                        Button {
                            print("downloading")
                        } label: {
                            if #available(macOS 14.0, *) {
                                UpdateIconView()
                                    .symbolEffect(.pulse.wholeSymbol, options: .repeating.speed(20), value: isFlashing)
                            } else {
                                UpdateIconView()
                            }
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            isFlashing = true
                        }
                    }
                    

                }
            }
        }
        .padding()
        .background {
            Color.Primary.LightBabyPowder
                .padding(-80)
        }
    }
}

struct UpdateIconView: View {
    var body: some View {
        Image(systemName: "arrow.down.circle")
            .resizable()
            .frame(width: 18, height: 18)
            .foregroundStyle(Color.Primary.Cavendish)
            .fontWeight(.bold)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .environmentObject(MainScreenViewModel(networkSource: NetworkManager()))
    }
}
