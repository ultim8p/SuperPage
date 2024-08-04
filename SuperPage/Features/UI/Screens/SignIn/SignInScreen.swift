//
//  SignInScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import SwiftUI
import AuthenticationServices

struct SignInScreen: View {
    
    @EnvironmentObject private var authState: AuthenticationState
    
    var body: some View {
        VStack {
            
            AppleSignInButton(handler: { credential in
                authState.postLogin(credential: credential)
            })
        }
        .padding()
    }
}

struct SignInScreen_Previews: PreviewProvider {
     
    static var previews: some View {
        SignInScreen()
            .environmentObject(AuthenticationState.mock)
    }
}
