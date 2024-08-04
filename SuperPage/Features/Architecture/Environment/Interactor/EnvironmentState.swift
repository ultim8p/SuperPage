//
//  EnvironmentState.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import SwiftUI
import NoAuth


class EnvironmentState: ObservableObject {
    
    enum EnvironmentType {
        case dev
        case prod
    }
    
    let env = EnvironmentType.prod
    
    let superPageKey = "R+bKodAXM8UmjZLdFZe3wHfLgYtohsWeo9/cRneEuUY="
    
    var userCredentials: ClientCredentials?
    
    var appCredentials: ClientCredentials? = ClientCredentials(
        _id: "6421a8b1b24bd4bb31f49781",
        publicKey: "YO913lKhiTbDU3Tm84dlCmGIPaJCJ6I/z1pLE44y/9E=",
        otpKey: "ejlwMmJDbmRuTlVuc0F0aWNHS2RxeTUxeTlVUHlRamhZdW4xQTRkbw==")
    
    var scheme: String {
        switch env {
        case .dev:
            return "http"
        case .prod:
            return "https"
        }
    }
    
    var host: String {
        switch env {
        case .dev:
            return "192.168.0.152"
        case .prod:
            return "superpage.cloud"
        }
    }
    
    var port: Int? {
        switch env {
        case .dev:
            return 6060
        case .prod:
            return nil
        }
    }
    
    init() {
        
    }
    
    func loadInitialState() {
        userCredentials = getUserCredentials()
    }
    
    func setUserCredentials(_ credentials: ClientCredentials?) {
        userCredentials = credentials
        UserDefaults.standard.setObject(credentials, forKey: "AuthenticatedUserCredentials")
    }
    
    func getUserCredentials() -> ClientCredentials? {
        UserDefaults.standard.getObject(forKey: "AuthenticatedUserCredentials")
    }
}
