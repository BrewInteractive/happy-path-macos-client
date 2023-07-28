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
                .resizable()
                .frame(width: 120, height: 120)
            Text(mainScreenVm.email)
                .foregroundColor(.Primary.DarkNight)
            Text("Click the + button below to add your first time entry.")
                .foregroundColor(.ShadesofCadetGray.CadetGray600)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
}

struct NoEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NoEntryView()
            .environmentObject(MainScreenViewModel())
    }
}
