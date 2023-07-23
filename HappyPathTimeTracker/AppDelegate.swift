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
        let magicToken = components?.queryItems?.first(where: {$0.name == "token"})?.value
        
        if magicToken != nil {
            Task {
                if let auth = await NetworkManager.getJwtTokenWithMagicToken(magicToken: magicToken!), let jwtToken = auth.token {
                    DispatchQueue.global().async {
                        let keychain = KeychainSwift()
                        keychain.set(jwtToken, forKey: K.token)
                    }
                    NotificationCenter.default.post(name: Notification.Name.loginByMagicLinkNotification, object: jwtToken)
                } else {
                    print("no auth found")
                }
            }
        } else {
            print("no token in url")
        }
    }
}
