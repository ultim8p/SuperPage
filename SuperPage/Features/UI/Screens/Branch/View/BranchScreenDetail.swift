//
//  BranchScreenDetail.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/24/24.
//

import SwiftUI

struct BranchScreenDetail: View {
    
//    @StateObject var branchEditState = BranchEditState()
    
    @EnvironmentObject var chatsState: ChatsState
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        Group {
            if !chatsState.hasChats {
                if chatsState.loadingChatsState == .loading {
                    EmptyLoadingView()
                } else {
                    EmptyCreateChatView()
                }
            } else {
                if navigationManager.selectedBranchRef != nil {
                    BranchScreen()
                } else {
                    EmptyHomeView()
//                    let selectedChatId = navigationManager.selectedChatId
//                    if let selectedChat = chatsState.chatFor(id: selectedChatId) {
//                        if chatsState.chatsStates[selectedChat.id] == .loading {
//                            EmptyHomeView()
//                        } else {
//                            let chatBranches = chatsState.branches[selectedChat.id]
//                            let hasBranches = !(chatBranches?.isEmpty ?? true)
//                            if hasBranches {
//                                EmptyHomeView()
//                            } else {
//                                EmptyCreateBranchView()
//                            }
//                        }
//                    } else {
//                        EmptyHomeView()
//                    }
                }
            }
        }
#if os(iOS)
        .toolbarBackground(AppColor.main.color, for: .navigationBar)
//                .toolbar(.hidden, for: .navigationBar)
#endif
    }
}
