//
//  APIRequestBuilder.swift
//  BotNotes
//
//  Created by Guerson Perez on 3/12/23.
//

import Foundation
import NoAPI
import NoAuth

extension Encodable {
    
    func request(_ env: EnvironmentInteractor,
                 method: APIMethod?,
                 path: APIPath?) throws -> APIBaseRequest {
        var request = try APIBaseRequest.request(env, method: method, path: path)
        
        if method == .get || method == .delete {
            request = try request.setQuery(object: self, using: JSONEncoder.mongoEncoder)
        } else {
            request = try request.setBody(self, using: JSONEncoder.mongoEncoder)
        }
        return request
    }
    
    static func get(_ env: EnvironmentInteractor, path: APIPath?) throws -> APIBaseRequest {
        let request = try APIBaseRequest.request(env, method: .get, path: path)
        return request
    }
}
