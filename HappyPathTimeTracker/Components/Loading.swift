//
//  Loading.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 10.02.2024.
//

import Foundation
import SwiftUI

struct Loading: View {
    var body: some View {
        ZStack {
            Color.Primary.DarkNight.opacity(0.2)
            ProgressView()
                .background {
                    Color.ShadesOfDark.D_04.opacity(0.3)
                }
        }
    }
}
