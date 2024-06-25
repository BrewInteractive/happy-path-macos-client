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
//                if mainScreenVm.appState?.isError == true {
//                    Image(systemName: "exclamationmark.triangle.fill")
//                        .foregroundColor(.Primary.Cavendish)
//                        .opacity(isFlashing ? 1.0 : 0.2)
//                        .animation(.easeIn(duration: 1).repeatForever(), value: isFlashing)
//                        .onHover(perform: { isHovered in
//                            isErrorInfoShown = isHovered
//                        })
//                        .onAppear{
//                            self.isFlashing = true
//                        }
//                        .popover(isPresented: $isErrorInfoShown) {
//                            ZStack {
//                                Rectangle()
//                                    .foregroundColor(Color.Primary.CadetGray)
//                                Text("Sistemde bir hata olustu, kontrol ediliyor...")
//                            }
//                        }
//                }
                Text("\(mainScreenVm.selectedDate.toFormat("EEEE, dd MMM"))")
                    .font(.figtree(weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 16, height: 16)
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
                Text("Version: \(Bundle.main.appVersionLong)")
                    .font(.figtree(size: 12))
                    .foregroundColor(.Primary.DarkNight)
            }
        }
        .padding()
        .background {
            Color.Primary.LightBabyPowder
                .padding(-80)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .environmentObject(MainScreenViewModel(networkSource: NetworkManager()))
    }
}
