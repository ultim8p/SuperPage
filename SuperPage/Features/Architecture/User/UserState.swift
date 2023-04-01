//
//  UserState.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation

struct UserState {
    
    var isSignedIn: Bool {
        return user != nil
    }
    
    var user: User?
    
}
