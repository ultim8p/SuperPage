//
//  SettingsRepository.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/30/23.
//

import Foundation
import NoAPI

enum SettingsPath: APIPath {
    
    case getSettingsMe
        
    var description: String {
        switch self {
        case .getSettingsMe:
            return "/v1/settings/usage/me"
        }
    }
}

class SettingsRepo {
    
    // MARK: - GET
    
    func getSettingsMe(env: EnvironmentInteractor)
    async throws -> SettingsUsage {
        return try await .get(env, path: SettingsPath.getSettingsMe)
            .authenticate(env: env)
            .responseValue()
    }
}
