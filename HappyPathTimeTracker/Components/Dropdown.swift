//
//  Dropdown.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 28.07.2023.
//

import SwiftUI

struct Dropdown: View {
    @State private var selectedText: String? = nil
    @State private var isContentShown: Bool = false
    let data = [1, 2, 3, 4, 5, 6]
    var body: some View {
        ZStack {
            ZStack(alignment: .trailing) {
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .foregroundColor(Color.ShadesofCadetGray.CadetGray50)
                    .onTapGesture {
                        isContentShown.toggle()
                    }
                Image(systemName: "chevron.down")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .fontWeight(.bold)
                    .frame(width: 16, height: 16)
                    .padding(.trailing, 10)
            }
            VStack {
                ForEach(data, id: \.self) { item in
                    Text("\(item)")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct Dropdown_Previews: PreviewProvider {
    static var previews: some View {
        Dropdown()
    }
}
