//
//  LargeButton.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 29.06.2024.
//

import Foundation
import SwiftUI

struct LargeButton: View {
    let title: String
    let color: Color = Color.ShadesOfTeal.Teal_300
    let disabled: Bool
    let isLoading: Bool
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick, label: {
            Text(title)
                .foregroundStyle(Color.Primary.RealWhite)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(disabled ? Color.ShadesofCadetGray.CadetGray200 : color)
                }
                .disabled(disabled || isLoading)
        })
    }
}

#Preview {
    LargeButton(title: "Signin", disabled: false, isLoading: true) {
        print("signin clicked")
    }
}
