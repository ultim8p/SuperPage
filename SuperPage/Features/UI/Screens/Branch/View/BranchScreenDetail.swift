//
//  BranchScreenDetail.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/24/24.
//

import SwiftUI

struct BranchScreenDetail: View {
    
//    @StateObject var branchEditState = BranchEditState()
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        Group {
            if !chatInt.hasChats {
                if chatInt.loadingChatsState == .loading {
                    EmptyLoadingView()
                } else {
                    EmptyCreateChatView()
                }
            } else {
                if navigationManager.selectedBranchId != nil {
                    BranchScreen()
                } else {
                    let selectedChatId = navigationManager.selectedChatId
                    if let selectedChat = chatInt.chat(for: selectedChatId)?.chat {
                        let state = selectedChat.state ?? .ok
                        if state == .loading {
                            EmptyHomeView()
                        } else {
                            let hasBranches = !(selectedChat.branches?.isEmpty ?? true)
                            if hasBranches {
                                EmptyHomeView()
                            } else {
                                EmptyCreateBranchView()
                            }
                        }
                    } else {
                        EmptyHomeView()
                    }
                }
            }
        }
#if os(iOS)
        .toolbarBackground(AppColor.main.color, for: .navigationBar)
//                .toolbar(.hidden, for: .navigationBar)
#endif
    }
}
