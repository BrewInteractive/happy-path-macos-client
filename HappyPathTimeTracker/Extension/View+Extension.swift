//
//  View+Extension.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 6.02.2024.
//

import Foundation
import SwiftUI

extension View {
    func sync(_ published: Binding<Bool>, with binding: Binding<Bool>) -> some View {
        self
            .onChange(of: published.wrappedValue) { newVal in
                binding.wrappedValue = newVal
            }
            .onChange(of: binding.wrappedValue) { newValue in
                published.wrappedValue = newValue
            }
    }
}
