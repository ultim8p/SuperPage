//
//  ContentView.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Window State
    
    @StateObject var branchEditState = BranchEditState()
    
    @StateObject var navigationManager = NavigationManager()
    
    // MARK: Global State
    
    @EnvironmentObject var chatsState: ChatsState
    
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        ZStack {
            AppColor.mainSecondary.color
                .ignoresSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if userState.isSignedIn {
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
        branchEditState.inject(chatsState: chatsState, navManager: navigationManager)
    }
}

struct ContentView_Previews: PreviewProvider {
                            
    static var previews: some View {
        ContentView()
            .environmentObject(ChatsState.mock)
            .environmentObject(UserState.mock)
    }
}
