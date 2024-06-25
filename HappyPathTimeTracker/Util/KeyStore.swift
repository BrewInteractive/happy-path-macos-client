//
//  KeyStore.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 23.06.2024.
//

import Foundation
import os

class KeyStore {
    
    let account = "happy-auth-token"
    let group = "MEXY5CM4N3.com.gorkemsevim.HappyPathTimeTracker.sharedItems"
    
    func store(key: String, value : String) {
        let data = value.data(using: .utf8)!
        let addquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword as String,
                                       kSecAttrLabel as String: key,
                                       kSecAttrAccount as String: account,
                                       kSecValueData as String: data,
                                       kSecAttrSynchronizable as String : kCFBooleanTrue!,
                                       kSecAttrAccessGroup as String : group
        ]
        SecItemDelete(addquery as CFDictionary)
        let status : OSStatus = SecItemAdd(addquery as CFDictionary, nil)
        print("store status: ", status)
        guard status == errSecSuccess else {
            os_log("store: whoops: ", status)
            return
        }
    }
    
    func clear() {
        let addquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword as String,
                                       kSecAttrAccount as String: account,
                                       kSecAttrSynchronizable as String : kCFBooleanTrue!,
                                       kSecAttrAccessGroup as String : group
        ]
        SecItemDelete(addquery as CFDictionary)
    }
    
    func retrieve(key: String) -> String? {
        print("key: ", key)
        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrLabel as String: key,
                                       kSecAttrAccount as String: account,
                                       kSecReturnData as String: kCFBooleanTrue!,
                                       kSecMatchLimit as String : kSecMatchLimitOne,
                                       kSecAttrSynchronizable as String : kCFBooleanTrue!,
                                       kSecAttrAccessGroup as String : group
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        print("get status: ", status)
        guard status == errSecSuccess else {
            os_log("keyStore.retrieve SecItemCopyMatching error \(status)")
            return nil
        }
        
        guard let data = item as? Data? else {
            os_log("keyStore.retrieve not data")
            return nil
        }
        let encoded = String(data: data!, encoding: String.Encoding.utf8)
        return encoded
    }
    
}
