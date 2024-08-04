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
    
    func request(
        _ env: EnvironmentState,
        method: APIMethod?,
        path: APIPath?,
        scheme: String,
        host: String,
        port: Int?
    ) throws -> APIBaseRequest {
        var request = try APIBaseRequest.request(
            env,
            method: method,
            path: path,
            scheme: scheme,
            host: host,
            port: port
        )
        
        if method == .get || method == .delete {
            request = try request.setQuery(object: self, using: JSONEncoder.mongoEncoder)
        } else {
            request = try request.setBody(self, using: JSONEncoder.mongoEncoder)
        }
        return request
    }
    
    static func get(
        _ env: EnvironmentState,
        path: APIPath?,
        scheme: String,
        host: String,
        port: Int?
    ) throws -> APIBaseRequest {
        let request = try APIBaseRequest.request(
            env,
            method: .get,
            path: path,
            scheme: scheme,
            host: host,
            port: port
        )
        return request
    }
}
