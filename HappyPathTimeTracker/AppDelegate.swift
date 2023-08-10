//
//  AppDelegate.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 9.07.2023.
//

import Foundation
import AppKit
import KeychainSwift

class AppDelegate: NSObject, NSApplicationDelegate {
    
    // will run with deeplink
    func application(_ application: NSApplication, open urls: [URL]) {
        let components = URLComponents(url: urls[0], resolvingAgainstBaseURL: false)
        let token = components?.queryItems?.first(where: {$0.name == "token"})?.value
        if let tokenData = token?.data(using: .utf8) {
            if let encodedToken = Data(base64Encoded: tokenData) {
                if let encodedToken = try? JSONDecoder().decode(Auth.self, from: encodedToken),
                    let tokenString = encodedToken.token{
                    DispatchQueue.global().async {
                        let keychain = KeychainSwift()
                        keychain.set(tokenString, forKey: K.token)
                    }
                    NotificationCenter.default.post(name: Notification.Name.loginByMagicLinkNotification, object: tokenString)
                }
            }
        } else {
            print("no token in url")
        }
    }
}
