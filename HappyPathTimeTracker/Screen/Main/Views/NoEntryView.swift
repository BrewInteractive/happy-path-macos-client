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
            Text(mainScreenVm.email)
                .foregroundColor(.Primary.DarkNight)
            Text("Click the + button below to add your first time entry.")
                .foregroundColor(.ShadesofCadetGray.CadetGray600)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NoEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NoEntryView()
            .environmentObject(MainScreenViewModel())
    }
}
