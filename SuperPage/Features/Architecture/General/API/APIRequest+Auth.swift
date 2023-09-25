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
    
    func authenticate(env: EnvironmentInteractor) throws -> Self {
        var credentials: [ClientCredentials] = []
        if let appCredentials = env.state.appCredentials {
            credentials.append(appCredentials)
        }
        if let userCredentials = env.state.userCredentials {
            credentials.append(userCredentials)
        }
        return try authenticate(publicKey: env.state.superPageKey, credentials: credentials)
    }
    
    func authenticate(publicKey: String? = nil, credentials: [ClientCredentials]? = nil) throws -> Self {
        guard let publicKey = publicKey,
              let authString = try publicKey.apiAuthBearer(credentials: credentials)
        else { return self }
        return addHeaders(["Authorization": "Bearer \(authString)"])
    }
}
