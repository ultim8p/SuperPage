//
//  UserDefaults+Helpers.swift
//  SuperPage
//
//  Created by Guerson Perez on 8/7/23.
//

import Foundation

extension UserDefaults {
    func setObject<T: Codable>(_ value: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            self.set(encoded, forKey: key)  // Use 'self' to call the method from UserDefaults
        }
    }

    func getObject<T: Codable>(forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
