//
//  EmptyCreateBranchView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/25/24.
//

import SwiftUI

struct EmptyCreateBranchView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    var body: some View {
        ZStack {
            AppColor.main.color
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            VStack(alignment: .center) {
                Spacer()
                HStack {
                    Spacer()
                    CompButton {
                        openCreate()
                    } label: {
                        VStack {
                            CompIcon(size: .xLarge, iconSize: .xLarge, icon: .docBadgePlus, color: .highlight)
                            Text("Create Page.")
                                .compText(fontStyle: .body)
                        }
                    }
                    Spacer()
                }
                Spacer()
#if os(iOS)
                CompButton {
                    openCreate()
                } label: {
                    Text("Create Page")
                        .compText(fontStyle: .title3, fontWeight: .bold)
                        .componentMainButton()
                    
                }
                .padding()
#endif
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func openCreate() {
        var chat: Chat? = nil
        if let chatId = navigationManager.selectedChatId,
           let selectedChat = chatInt.chat(for: chatId)?.chat {
            chat = selectedChat
        } else if let firstChat = chatInt.chats.first {
            chat = firstChat
        }
        guard let chat else { return }
        
        navigationManager.fromChatCreatingBranch = chat
    }
}

