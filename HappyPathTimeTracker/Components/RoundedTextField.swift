//
//  RoundedTextField.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 29.06.2024.
//

import Foundation
import SwiftUI

struct RoundedTextField: View {
    @Binding var text: String
    var type: TextFieldType = .text
    @State private var isSecure: Bool = true
    
    var body: some View {
        HStack {
            if type == .text || !isSecure {
                TextField("", text: $text)
                    .textFieldStyle(.plain)
                    .foregroundColor(.Primary.DarkNight)
                    .padding(5)
            } else {
                SecureField("", text: $text)
                    .textFieldStyle(.plain)
                    .foregroundColor(.Primary.DarkNight)
                    .padding(5)
            }
            
            if type == .password {
                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .resizable()
                        .frame(width: 16, height: 12)
                        .foregroundColor(Color.ShadesOfTeal.Teal_300)
                }
                .padding(5)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.ShadesofCadetGray.CadetGray200)
        )
    }
}

enum TextFieldType {
    case text
    case password
}
