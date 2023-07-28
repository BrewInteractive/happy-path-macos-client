//
//  HeaderView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    let selectedDate: Date
    @State private var isInfoShown: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.ShadesOfTeal.Teal_400)
                .frame(height:36)
            HStack {
                Text(selectedDate.toFormat("EEEE, dd MMM"))
                    .font(.body)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .popover(isPresented: $isInfoShown, content: {
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
                                        Text(mainScreenVm.todayTotalDurationWithActiveTimer)
                                    }
                                    .foregroundColor(.Primary.DarkNight)
                                    Rectangle()
                                        .fill(Color.ShadesOfTeal.Teal_400.opacity(0.2))
                                        .frame(width: 1)
                                        .frame(maxHeight: .infinity)
                                    VStack {
                                        Text("Hours Yesterday")
                                        Text("\(mainScreenVm.stats?.byInterval[3].totalDuration.minuteToHours ?? "00:00")")
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
                                        Text(mainScreenVm.thisWeekDurationWithActiveTimer)
                                    }
                                    .foregroundColor(.Primary.DarkNight)
                                    Rectangle()
                                        .fill(Color.ShadesOfTeal.Teal_400.opacity(0.2))
                                        .frame(width: 1)
                                        .frame(maxHeight: .infinity)
                                    VStack {
                                        Text("Hours This Month")
                                        Text(mainScreenVm.thisMonthDurationWithActiveTimer)
                                    }
                                    .foregroundColor(.Primary.DarkNight)
                                }
                            }
                        }
                        .padding()
                        .frame(width: 300)
                        .background {
                            Color.Primary.LightBabyPowder
                                .padding(-80)
                        }
                    })
                    .onTapGesture {
                        isInfoShown.toggle()
                    }
            }
            .padding(.horizontal, 8)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(selectedDate: Date())
    }
}
