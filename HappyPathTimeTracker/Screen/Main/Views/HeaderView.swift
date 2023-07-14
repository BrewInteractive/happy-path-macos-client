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
                .fill(
                    LinearGradient(colors: [
                        Color("Header2"), Color("Header1")],
                                   startPoint: .leading, endPoint: .trailing))
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
                            Text("Time Summary")
                            Divider()
                            Grid() {
                                GridRow {
                                    VStack {
                                        Text("Hours Today")
                                        Text("0:00")
                                    }
                                    Rectangle()
                                        .fill(.secondary.opacity(0.5))
                                        .frame(width: 1)
                                        .frame(maxHeight: .infinity)
                                    VStack {
                                        Text("Hours Yesterday")
                                        Text("0:00")
                                    }
                                }
                                Rectangle()
                                    .fill(.secondary.opacity(0.5))
                                    .frame(height: 1)
                                    .frame(maxWidth: .infinity)
                                GridRow {
                                    VStack {
                                        Text("Hours This Week")
                                        Text("0:00")
                                    }
                                    Rectangle()
                                        .fill(.secondary.opacity(0.5))
                                        .frame(width: 1)
                                        .frame(maxHeight: .infinity)
                                    VStack {
                                        Text("Hours This Month")
                                        Text("0:00")
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(width: 300)
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
