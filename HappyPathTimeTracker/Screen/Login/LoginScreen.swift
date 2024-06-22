//
//  LoginScreen.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 13.09.2023.
//

import SwiftUI
import KeychainSwift

struct LoginScreen: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            Button {
                openURL(URL(string: K.openURLText)!)
            } label: {
                Text("Please Login")
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
