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
    
    @State var selectedBranchId: Branch.ID?
    
    @State var systemRole: String = ""
    
    var body: some View {
        ZStack {
            Button(action: {
                guard let selectedBranchId else { return }
                navigationManager.editingBranch = chatInt.branch(id: selectedBranchId)
            }, label: {})
            .buttonStyle(.borderless)
            .keyboardShortcut("e", modifiers: .command)
            
            NavigationSplitView {
                ChatsListView(
                    branchName: $branchName,
                    showBranchCreation: $showBranchCreation,
                    chatContextMenu: $chatContextMenu,
                    selectedBranchId: $selectedBranchId,
                    selectedChat: .constant(nil)
                )
                Spacer()
                HomeToolBar(showChatCreation: $showChatCreation)
            } detail: {
                if let selectedBranchId, let branch = chatInt.branch(id: selectedBranchId) {
                    BranchViewControllerWrapper(
                        systemRole: $systemRole,
                        selectedBranchId: $selectedBranchId,
                        chatInteractor: chatInt,
                        sendMessageHandler: { message, model, messageIds in
                            print("should send msg")
                            sendMessage(message: message, model: model, branch: branch, messageIds: messageIds)
                        },
                        saveContextHandler: { systemRole in
                            print("should have settings")
                            saveSettings(systemRole: systemRole, branch: branch)
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
        .sheet(isPresented: $showTest) {
            NameEditView(presented: $showTest, placeholder: "Folder name...", title: "Edit Folder name")
                .onSubmitName { name in
                    chatInt.editChat(name: name, chat: chatContextMenu)
                }
        }
        
//        ZStack {
            /*
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
             */
//        }
//        .padding(.bottom)
//        .ignoresSafeArea(edges: [.bottom])
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
    
    func saveSettings(systemRole: String, branch: Branch) {
        self.systemRole = systemRole
        let settings: [String: Any] = [
            "sysRole": systemRole]
        chatInt.saveBranchSettings(id: branch.id, settings: settings)
    }
}

struct HomeScreen_Previews: PreviewProvider {
                            
    static var previews: some View {
        HomeScreen()
            .environmentObject(ChatInteractor.mock)
    }
}
