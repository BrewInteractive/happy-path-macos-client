//
//  BottomView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import SwiftUI

struct BottomView: View {
    @Binding var isNewEntryModalShown: Bool
    
    var body: some View {
        HStack {
            Button {
                isNewEntryModalShown.toggle()
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .buttonStyle(.borderless)
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
            .padding(.top, 4)
            .popover(isPresented: $isNewEntryModalShown) {
                NewTimeEntryView()
            }
            Spacer()
        }
    }
}

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        BottomView(isNewEntryModalShown: .constant(true))
    }
}
