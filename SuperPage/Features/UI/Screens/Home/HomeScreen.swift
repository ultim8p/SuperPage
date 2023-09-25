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
    
    // Selected Chat
    
    @State var selectedBranchId: Branch.ID?
    
    @State var systemRole: String = ""
    
    var body: some View {
        ZStack {
            NavigationSplitView {
                ChatsListView(
                    branchName: $branchName,
                    showBranchCreation: $showBranchCreation,
                    chatContextMenu: $chatContextMenu,
                    selectedBranchId: $selectedBranchId)
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
                    .onChange(of: selectedBranchId) { _ in
    //                            chatInt.messages = []
    //                            chatInt.getMessages(branch: branch)
//                        let settings = chatInt.branchSettings(id: branch.id)
//                        chatMode = settings["isOn"] as? Bool ?? false
//                        systemRole = settings["sysRole"] as? String ?? ""
                    }
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
