//
//  HomeScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation
import SwiftUI

struct HomeScreen: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @State var chatName: String = ""
    @State var branchName: String = ""
    
    @State private var showChatCreation = false
    @State private var showBranchCreation = false
    
    @State private var showTest = false
    
    @State private var chatContextMenu: Chat = Chat()
    
    // Selected Chat
    
    @State var systemRole: String = ""
    
    var body: some View {
        ZStack {
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
            
            NavigationSplitView {
                ChatsListView(
                    branchName: $branchName,
                    showBranchCreation: $showBranchCreation,
                    chatContextMenu: $chatContextMenu,
                    selectedChat: .constant(nil)
                )
                Spacer()
                HomeToolBar(showChatCreation: $showChatCreation)
            } detail: {
                if let selectedBranchId = navigationManager.selectedBranchId,
                   let branch = chatInt.branch(id: selectedBranchId) {
                    BranchViewControllerWrapper(
                        systemRole: $systemRole,
                        selectedBranchId: $navigationManager.selectedBranchId,
                        chatInteractor: chatInt,
                        sendMessageHandler: { message, model, messageIds in
                            print("should send msg")
                            sendMessage(message: message, model: model, branch: branch, messageIds: messageIds)
                        },
                        saveContextHandler: { systemRole in
                            print("should have settings")
//                            saveSettings(systemRole: systemRole, branch: branch)
                        }
                    )
                } else {
                    let hasChats = !chatInt.chats.isEmpty
                    let emptyStateText = hasChats ?
                    "Select a Page" :
                    "Create your frist folder and page to get stated"
                    Text(emptyStateText)
                }
            }
            .toolbarBackground(Color.branchBackground, for: .windowToolbar)
        }
        
        .sheet(
            item: $navigationManager.editingBranch,
            onDismiss: {},
            content: { branch in
                BranchEditView(
                    isCreating: branch._id == nil,
                    name: branch.name,
                    role: branch.promptRole?.text,
                    emoji: branch.promptEmoj,
                    editedHandler: { name, role, emoji in
                        guard branch._id != nil else { return }
                        var tags: [Tag]?
                        if let emoji {
                            tags = [Tag(type: .emoji, value: emoji)]
                        }
                        let role = Role(tags: tags, text: role)
                        chatInt.editBranch(branch: branch, name: name, promptRole: role)
                    }
                )
            }
        )
        
        .sheet(
            item: $navigationManager.fromChatCreatingBranch,
            onDismiss: {},
            content: { chat in
                BranchCreateView(
                    selectedChatId: chat.id) { name, role, emoji in
                        var tags: [Tag]?
                        if let emoji {
                            tags = [Tag(type: .emoji, value: emoji)]
                        }
                        let role = Role(tags: tags, text: role)
                        chatInt.createBranch(name: name, promptRole: role, chat: chat)
                    }
            }
        )
        
        .sheet(item: $navigationManager.creatingChat) { chat in
            ChatCreateView { name in
                chatInt.createChat(name: name)
            }
        }
        
        .sheet(item: $navigationManager.editingChat, onDismiss: {}) { chat in
            ChatEditView(name: chat.name ?? "") { name in
                chatInt.editChat(name: name, chat: chat)
            }
        }
    }
}

extension HomeScreen {
    
    func sendMessage(message: String, model: AIModel, branch: Branch, messageIds: [String]) {
        guard !message.isEmpty else { return }
        chatInt.postCreateMessage(
            text: message,
            model: model,
            branch: branch,
            messageIds: messageIds
        )
    }
}

struct HomeScreen_Previews: PreviewProvider {
                            
    static var previews: some View {
        HomeScreen()
            .environmentObject(ChatInteractor.mock)
    }
}
