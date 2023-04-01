//
//  AppleSignInButton.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    typealias Handler = (_ credential: ASAuthorizationAppleIDCredential) -> Void
    var handler: Handler?

    var body: some View {
      if colorScheme.self == .dark {
          SignInButton(SignInWithAppleButton.Style.whiteOutline)
      }
      else {
          SignInButton(SignInWithAppleButton.Style.black)
      }
    }

    func SignInButton(_ type: SignInWithAppleButton.Style) -> some View{
        return SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let authResults):
                guard let credential = authResults.credential as? ASAuthorizationAppleIDCredential
                else { return }
                handler?(credential)
            case .failure(let error):
                print("Authorisation failed: \(error.localizedDescription)")
            }
        }
        .frame(width: 280, height: 60, alignment: .center)
        .signInWithAppleButtonStyle(type)
    }
}


struct AppleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        AppleSignInButton()
    }
}


