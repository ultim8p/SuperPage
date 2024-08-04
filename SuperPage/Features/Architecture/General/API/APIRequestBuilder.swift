//
//  APIBaseRequestBuilder.swift
//  BotNotes
//
//  Created by Guerson Perez on 3/12/23.
//


import Foundation
import NoAPI
import NoCrypto
import NoAuth
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension APIRequestable {
    
    static func request(
        _ env: EnvironmentState,
        method: APIMethod? = nil,
        path: APIPath? = nil,
        scheme: String,
        host: String,
        port: Int?
    ) throws -> APIBaseRequest {
        var request = APIBaseRequest()
        request = try request.setScheme(scheme)
            .setHost(host)
            .setPort(port)
            .setMethod(method)
            .addBaseHeaders()
            .setTimeout(interval: TimeInterval(60.0 * 10.0))
        if let path = path {
            request = request.addPath(path.description)
        }
        return request
    }
}

extension APIBaseRequest {
    
    func addBaseHeaders() -> Self {
        var deviceString: String = ""
        #if os(iOS) || os(watchOS) || os(tvOS)
        deviceString = UIDevice.current.name
        #elseif os(macOS)
        deviceString = Host.current().name ?? ""
        #endif
        return addHeaders(["Content-Type": "application/json", "DeviceName": deviceString])
    }
}
