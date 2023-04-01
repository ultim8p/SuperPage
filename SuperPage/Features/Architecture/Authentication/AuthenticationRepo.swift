//
//  AuthenticationRepo.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import NoAuth
import NoAPI

enum AuthPath: APIPath {
        
    case postSignIn
    
    var description: String {
        switch self {
        case .postSignIn:
            return "/v1/signin"
        }
    }
}

class AuthenticationRepo {
    
    func postUserAuthenticate(env: EnvironmentInteractor,
                              request: SignInRequest
    ) async throws -> SignInResponse {
        return try await request.request(
            env, method: .post, path: AuthPath.postSignIn
        ).authenticate(env: env).responseValue()
    }
}
