//
//  HomeScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation
import SwiftUI

struct HomeScreen: View {
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @State var chatName: String = ""
    @State var branchName: String = ""
    
    @State private var showChatCreation = false
    @State private var showBranchCreation = false
    
    @State private var chatContextMenu: Chat = Chat()
    
    var body: some View {
        ZStack {
            VStack {
                ChatsListView(
                    branchName: $branchName,
                    showBranchCreation: $showBranchCreation,
                    chatContextMenu: $chatContextMenu)
                Spacer()
                HomeToolBar(showChatCreation: $showChatCreation)
            }
            if showChatCreation {
                ChatCreationView(presented: $showChatCreation, name: $chatName)
            }
            if showBranchCreation {
                BranchCreationView(
                    presented: $showBranchCreation,
                    name: $branchName,
                    chat: $chatContextMenu)
            }
        }
        .padding(.bottom)
//        .statusBarHidden(true)
        .ignoresSafeArea(edges: [.top, .bottom])
    }
}

struct HomeScreen_Previews: PreviewProvider {
                            
    static var previews: some View {
        HomeScreen()
            .environmentObject(ChatInteractor.mock)
    }
}

