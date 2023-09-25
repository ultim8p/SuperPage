//
//  ChatRow.swift
//  SuperPage
//
//  Created by Guerson Perez on 8/7/23.
//

import Foundation
import SwiftUI

struct ChatRow: View {
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @Binding var chat: Chat
    
    @Binding var chatContextMenu: Chat
    
    @Binding var showBranchCreation: Bool
    
    @Binding var showEditChat: Bool
    
    @Binding var showChatDeleteAlert: Bool
    
    var body: some View {
        let expanded = chat.expanded ?? false
        FileRow(
            name: chat.name ?? "No name",
            folder: true,
            isExpanded: expanded,
            loading: chat.state == .loading,
            hasError: false
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                chatInt.toggleExpand(chat: chat)
            }
        }
        .contextMenu {
            Button("Create Page") {
                chatContextMenu = chat
                showBranchCreation = true
            }
            Button("Rename Folder") {
                chatContextMenu = chat
                showEditChat = true
            }
            Button("Delete Folder") {
                chatContextMenu = chat
                showChatDeleteAlert = true
            }
        }
        .alert(
            "After hitting Delete this Folder will be permanently deleted.",
            isPresented: $showChatDeleteAlert)
        {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                chatInt.deleteChat(chat: chatContextMenu)
            }
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
                            
    static var previews: some View {
        ChatRow(
            chat: .constant(Chat(name: "Test Chat")),
            chatContextMenu: .constant(Chat()),
            showBranchCreation: .constant(false),
            showEditChat: .constant(false),
            showChatDeleteAlert: .constant(false))
            .environmentObject(ChatInteractor.mock)
    }
}
