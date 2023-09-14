//
//  NoEntryView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 27.07.2023.
//

import Foundation
import SwiftUI

struct NoEntryView: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Image("Log-Alert")
            VStack(alignment: .leading, spacing: 8) {
                Text(mainScreenVm.email)
                    .foregroundColor(.Primary.DarkNight)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Click the + button below to add your first time entry.")
                    .font(.figtree(size: 13))
                    .foregroundColor(.ShadesofCadetGray.CadetGray600)
            }
            Spacer()
        }
        .padding(20)
    }
}

struct NoEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NoEntryView()
            .environmentObject(MainScreenViewModel(networkSource: NetworkManager()))
    }
}
