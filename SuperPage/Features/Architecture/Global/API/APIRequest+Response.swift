//
//  APIRequest+Response.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import NoAPI

extension APIRequestable {
    
    func responseValue<T: Codable>() async throws -> T {
        return try await response().baseValue()
    }
    
    func responseOptionalValue<T: Codable>() async throws -> T? {
        return try await response().baseOptionalValue()
    }
}

/*
 extension APIBaseRequest {
     
     func responseValue<Response: Codable>() async throws -> Response {
         return try await response().baseValue()
     }
     
     func responseOptionalValue<Response: Codable>() async throws -> Response? {
         return try await response().baseOptionalValue()
     }
 }
 */
