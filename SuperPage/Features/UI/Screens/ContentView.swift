//
//  ContentView.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var branchEditState = BranchEditState()
    @StateObject var navigationManager = NavigationManager()
    
    @EnvironmentObject private var userInt: UserInteractor
    @EnvironmentObject private var authInt: AuthenticationInteractor
    @EnvironmentObject private var chatInt: ChatInteractor
    
    var body: some View {
        ZStack {
            AppColor.mainSecondary.color
                .ignoresSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                    if userInt.state.isSignedIn {
                        HomeScreen()
                            .environmentObject(navigationManager)
                            .environmentObject(branchEditState)
                            .onAppear {
                                self.setupState()
                            }
                    } else {
                        SignInScreen()
                    }
        }
    }
}

extension ContentView {
    
    func setupState() {
        branchEditState.inject(chatInt: chatInt, navManager: navigationManager)
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
