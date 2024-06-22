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
    @State private var token: String = ""
    
    var body: some View {
        VStack {
            Button {
                openURL(URL(string: K.openURLText)!)
            } label: {
                Text("Please Login")
            }
            Spacer()
            TextField("", text: $token)
        }
        .onAppear {
            let keychain = KeychainSwift()
            let kToken = keychain.get(K.token)
            token = kToken ?? ""
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
