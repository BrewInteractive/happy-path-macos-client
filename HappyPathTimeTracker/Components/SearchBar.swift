//
//  SearchBar.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 15.10.2023.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    let placeholder: String
    @Binding var searchText: String
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if searchText.isEmpty {
                Text(placeholder)
                    .font(.figtree(size: 14, weight: .regular))
                    .foregroundStyle(Color.ShadesofCadetGray.CadetGray500)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            TextField("", text: $searchText)
                .foregroundStyle(Color.ShadesofCadetGray.CadetGray500)
                .textFieldStyle(.plain)
            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(.link)
            } else {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.ShadesofCadetGray.CadetGray500)
            }
        }
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 5.0)
                .strokeBorder(Color.ShadesofCadetGray.CadetGray200,
                              style: StrokeStyle(lineWidth: 1.0))
        )
    }
}

#Preview {
    SearchBar(placeholder: "Search ...", searchText: .constant(""))
        .preferredColorScheme(.dark)
}

#Preview {
    SearchBar(placeholder: "Search ...", searchText: .constant(""))
        .preferredColorScheme(.light)
}
