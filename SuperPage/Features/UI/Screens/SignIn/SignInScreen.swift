//
//  SignInScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import SwiftUI
import AuthenticationServices

struct SignInScreen: View {
    
    @EnvironmentObject private var userInteractor: UserInteractor
    @EnvironmentObject private var authInteractor: AuthenticationInteractor
    
    var body: some View {
        VStack {
            Text(userInteractor.state.user?.username ?? "")
            AppleSignInButton(handler: { credential in
                authInteractor.postLogin(credential: credential)
            })
        }
        .padding()
    }
}

struct SignInScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        SignInScreen()
            .environmentObject(UserInteractor.mock)
            .environmentObject(AuthenticationInteractor.mock)
    }
}
