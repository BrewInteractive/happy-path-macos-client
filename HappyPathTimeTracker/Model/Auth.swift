//
//  Token.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 20.07.2023.
//

import Foundation

struct Auth: Decodable {
    let metadata: Metadata?
    let token: String?
}

struct Metadata: Decodable {
    let issuer, publicAddress, email, oauthProvider, phoneNumber: String?
    let wallets: [String]?
}
