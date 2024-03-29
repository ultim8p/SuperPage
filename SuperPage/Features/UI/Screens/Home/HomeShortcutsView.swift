//
//  HomeShortcutsView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/24/24.
//

import SwiftUI

struct HomeShortcutsView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    var body: some View {
        Button(action: {
            guard let selectedBranchId = navigationManager.selectedBranchId else { return }
            navigationManager.editingBranch = chatInt.branch(id: selectedBranchId)
        }, label: {})
        .buttonStyle(.borderless)
        .keyboardShortcut("e", modifiers: .command)
        
        Button(action: {
            var chat: Chat? = nil
            if let chatId = navigationManager.selectedChatId,
               let selectedChat = chatInt.chat(for: chatId)?.chat {
                chat = selectedChat
            } else if let firstChat = chatInt.chats.first {
                chat = firstChat
            }
            guard let chat else { return }
            
            navigationManager.fromChatCreatingBranch = chat
        }, label: {})
        .buttonStyle(.borderless)
        .keyboardShortcut("p", modifiers: .command)
    }
}
