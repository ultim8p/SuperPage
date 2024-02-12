//
//  ChatRow.swift
//  SuperPage
//
//  Created by Guerson Perez on 8/7/23.
//

import Foundation
import SwiftUI

struct ChatRow: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @Binding var chat: Chat
    
    @Binding var chatContextMenu: Chat
    
    @Binding var selectedChatId: Chat.ID?
    
    @Binding var showEditChat: Bool
    
    @Binding var showChatDeleteAlert: Bool
    
    var selectionHandler: (() -> Void)?
    
    var body: some View {
        let expanded = chat.expanded ?? false
        let isSelected = selectedChatId == chat.id
        
        FileRow(
            name: chat.name ?? "No name",
            isExpanded: expanded,
            loading: chat.state == .loading,
            hasError: false
        )
        .frame(maxWidth: .infinity)
        .frame(height: 22.0)
        .background(
            Group {
                if isSelected {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.spAction)
                        .padding(.leading, 8)
                        .padding(.trailing, 8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Color.clear
                }
            }
        )
    
        .contentShape(Rectangle())
        .onTapGesture {
            selectionHandler?()
        }
        .contextMenu {
            Button("Create Page") {
//                chatContextMenu = chat
                navigationManager.fromChatCreatingBranch = chat
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
            selectedChatId: .constant(nil),
            showEditChat: .constant(false),
            showChatDeleteAlert: .constant(false)
        )
            .environmentObject(ChatInteractor.mock)
    }
}
