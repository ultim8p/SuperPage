//
//  EnvironmentInteractor.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import SwiftUI
import NoAuth

class EnvironmentInteractor: ObservableObject {
    
    @Published var state: EnvironmentState
    
//    var userCredId: String? {
//        set {
//            UserDefaults.standard.set(newValue, forKey: "userCredId")
//        }
//        get {
//            return UserDefaults.standard.string(forKey: "userCredId")
//        }
//    }
//
//    var userCredKey: String? {
//        set {
//            UserDefaults.standard.set(newValue, forKey: "userCredKey")
//        }
//        get {
//            return UserDefaults.standard.string(forKey: "userCredKey")
//        }
//    }
//
//    var userCredOTP: String? {
//        set {
//            UserDefaults.standard.set(newValue, forKey: "userCredOTP")
//        }
//        get {
//            return UserDefaults.standard.string(forKey: "userCredOTP")
//        }
//    }
    
    init(state: EnvironmentState) {
        self.state = state
    }
    
//    var userCredentials: ClientCredentials? {
//        guard let userCredId, let userCredKey, let userCredOTP else { return nil }
//        return ClientCredentials(_id: userCredId, publicKey: userCredKey, otpKey: userCredOTP)
//    }
}
