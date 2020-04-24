//
//  KeyChain.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation


// MARK: KeyChain
/// The `KeyChain` allows a simple interaction with the iOS Keychain API
enum KeyChain {
    /// Load a `String` from the Keychain
    /// - Parameter service: The service that is identifiying the `element` in the Keychain
    /// - Returns: The element that is loaded from the Keychain
    static func load(_ service: String) -> String? {
        let query = self.query(service)
        var dataTypeRef: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        return (dataTypeRef as? Data)
            .flatMap { String(data: $0, encoding: .utf8) }
    }
    
    /// Store a `String` to the Keychain
    /// - Parameters:
    ///   - element: The `String` that should be stored in the Keychain
    ///   - service: The service that is identifiying the `element` in the Keychain
    static func store(element: String, for service: String) {
        deleteElement(for: service)
        
        let query = self.query(element, for: service)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    /// Delete an element in the Keychain
    /// - Parameter service: The service that is identifiying the `element` in the Keychain
    static func deleteElement(for service: String) {
        let query = self.query(for: service)
        SecItemDelete(query as CFDictionary)
    }
    
    /// Creates a Keychain query that can be used to add an element to the Keychain
    /// - Parameters:
    ///   - element: The element that should be added to the Keychain
    ///   - service: The service that is identifiying the `element` in the Keychain
    ///   - securityClass: The Keychain security class. The default value is `kSecClassGenericPassword`
    /// - Returns: The query as a `[String: Any]` dictionary that can be used with the `SecItem...` APIs
    private static func query(_ element: String = "",
                              for service: String,
                              securityClass: CFString = kSecClassGenericPassword) -> [String: Any] {
        [
            kSecClass as String: securityClass as String,
            kSecAttrAccount as String: service,
            kSecValueData as String: Data(element.utf8)
        ]
    }
    
    /// Creates a Keychain query that can be used to retrieve an element from the Keychain
    /// - Parameters:
    ///   - service: The service that is identifiying the `element` in the Keychain
    ///   - securityClass: The Keychain security class. The default value is `kSecClassGenericPassword`
    /// - Returns: The query as a `[String: Any]` dictionary that can be used with the `SecItem...` APIs
    private static func query(_ service: String, securityClass: CFString = kSecClassGenericPassword) -> [String: Any] {
        [
            kSecClass as String: securityClass,
            kSecAttrAccount as String: service,
            kSecReturnData as String: kCFBooleanTrue!, //swiftlint:disable:this force_unwrapping
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
    }
}
