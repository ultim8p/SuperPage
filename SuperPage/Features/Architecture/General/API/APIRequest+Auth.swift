//
//  APIRequest+Auth.swift
//  BotNotes
//
//  Created by Guerson Perez on 3/18/23.
//

import Foundation
import NoAPI
import NoAuth

extension APIRequestable {
    
    @MainActor
    func authenticate(env: EnvironmentState) throws -> Self {
        var credentials: [ClientCredentials] = []
        if let appCredentials = env.appCredentials {
            credentials.append(appCredentials)
        }
        if let userCredentials = env.userCredentials {
            credentials.append(userCredentials)
        }
        return try authenticate(publicKey: env.superPageKey, credentials: credentials)
    }
    
    func authenticate(publicKey: String? = nil, credentials: [ClientCredentials]? = nil) throws -> Self {
        guard let publicKey = publicKey,
              let authString = try publicKey.apiAuthBearer(credentials: credentials)
        else { return self }
        return addHeaders(["Authorization": "Bearer \(authString)"])
    }
}
