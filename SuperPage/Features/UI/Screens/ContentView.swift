//
//  ContentView.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var userInt: UserInteractor
    @EnvironmentObject private var authInt: AuthenticationInteractor
    @EnvironmentObject private var chatInt: ChatInteractor
    
    var body: some View {
        if userInt.state.isSignedIn {
            HomeScreen()
        } else {
            SignInScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
                            
    static var previews: some View {
        ContentView()
            .environmentObject(ChatInteractor.mock)
            .environmentObject(AuthenticationInteractor.mock)
            .environmentObject(UserInteractor.mock)
    }
}
