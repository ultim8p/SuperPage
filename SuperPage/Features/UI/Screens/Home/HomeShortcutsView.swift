//
//  HomeShortcutsView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/24/24.
//

import SwiftUI

struct HomeShortcutsView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @EnvironmentObject var chatsState: ChatsState
    
    var body: some View {
        Button(action: {
            guard let selectedBranchRef = navigationManager.selectedBranchRef else { return }
            navigationManager.editingBranch = chatsState.branchFor(branchRef: selectedBranchRef)
        }, label: {})
        .buttonStyle(.borderless)
        .keyboardShortcut("e", modifiers: .command)
        
        Button(action: {
            var chat: Chat? = nil
            if let chatId = navigationManager.selectedChatId,
               let selectedChat = chatsState.chat(for: chatId)?.chat {
                chat = selectedChat
            } else if let firstChat = chatsState.chats.first {
                chat = firstChat
            }
            guard let chat else { return }
            
            navigationManager.fromChatCreatingBranch = chat
        }, label: {})
        .buttonStyle(.borderless)
        .keyboardShortcut("p", modifiers: .command)
    }
}
