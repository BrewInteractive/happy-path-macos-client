//
//  RoundedContainer.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 29.06.2024.
//

import Foundation
import SwiftUI

struct RoundedContainer<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        GeometryReader { proxy in
            content()
                .padding(24)
                .background {
                    Color.Primary.RealWhite
                }
                .frame(width: proxy.size.width * 0.8)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
