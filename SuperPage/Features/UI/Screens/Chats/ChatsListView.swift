//
//  ChatsScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
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
        FileRow(name: chat.name ?? "No name", folder: true, isExpanded: expanded)
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

struct BranchRow: View {
    
    @EnvironmentObject var chatInt: ChatInteractor
    @Binding var branch: Branch
    @Binding var branchContextMenu: Branch
    @Binding var showEditBranch: Bool
    @Binding var showBranchDeleteAlert: Bool
    
    @State var systemRole: String = ""
    @State var chatMode: Bool = false
    
    var body: some View {
        NavLink(
            
            destination: BranchViewControllerWrapper(
                messages: $chatInt.messages,
                systemRole: $systemRole,
                chatMode: $chatMode,
                sendMessageHandler: { message in
                    sendMessage(message: message)
                },
                saveContextHandler: { systemRole, chatMode in
                    saveSettings(systemRole: systemRole, chatMode: chatMode)
                }
            )
            .onAppear {
                chatInt.messages = []
                chatInt.getMessages(branch: branch)
                
                let settings = chatInt.branchSettings(id: branch.id)
                chatMode = settings["isOn"] as? Bool ?? false
                systemRole = settings["sysRole"] as? String ?? ""
            }
        ) {
            HStack {
                FileRow(name: branch.name ?? "No name", folder: false, isExpanded: false)
            }
        }
        .contextMenu {
            Button("Rename Page") {
                branchContextMenu = branch
                showEditBranch = true
            }
            Button("Delete Page") {
                branchContextMenu = branch
                showBranchDeleteAlert = true
            }
        }
        .alert(
            "After hitting Delete this Page will be permanently deleted.",
            isPresented: $showBranchDeleteAlert)
        {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                chatInt.deleteBranch(branch: branchContextMenu)
            }
        }
    }
}

extension BranchRow {
    
    func sendMessage(message: String) {
        guard !message.isEmpty else { return }
        chatInt.postCreateMessage(
            text: message,
            branch: branch,
            independentMessages: !chatMode,
            systemMessage: systemRole)
    }
    
    func saveSettings(systemRole: String, chatMode: Bool) {
        self.chatMode = chatMode
        self.systemRole = systemRole
        let settings: [String: Any] = [
            "isOn": chatMode,
            "sysRole": systemRole]
        chatInt.saveBranchSettings(id: branch.id, settings: settings)
    }
}

struct ChatsListView: View {
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @Binding var branchName: String
    
    @Binding var showBranchCreation: Bool
    
    @Binding var chatContextMenu: Chat
    
    @State var branchContextMenu: Branch = Branch()
    
    @State var showChatMenu: Bool = false
    
    @State var showChatDeleteAlert: Bool = false
    
    @State var showBranchDeleteAlert: Bool = false
    
    @State var showEditChat: Bool = false
    
    @State var showEditBranch: Bool = false
    
    var body: some View {
        List {
            ForEach(chatInt.chats) { chat in
                ChatRow(chat: .constant(chat),
                        chatContextMenu: $chatContextMenu,
                        showBranchCreation: $showBranchCreation,
                        showEditChat: $showEditChat,
                        showChatDeleteAlert: $showChatDeleteAlert)
                
                if chat.expanded ?? false {
                    ForEach(chat.branches ?? []) { branch in
                        BranchRow(branch: .constant(branch),
                                  branchContextMenu: $branchContextMenu,
                                  showEditBranch: $showEditBranch,
                                  showBranchDeleteAlert: $showBranchDeleteAlert)
                    }
                }
            }
            .ignoresSafeArea(edges: [.top, .bottom])
            .listRowInsets(.init())
            .listRowBackground(Color.clear)
        }
        .frame(minWidth: 200.0, maxWidth: 400.0)
        .sheet(isPresented: $showEditChat) {
            NameEditView(presented: $showEditChat, placeholder: "Folder name...", title: "Edit Folder name")
                .onSubmitName { name in
                    chatInt.editChat(name: name, chat: chatContextMenu)
                }
        }
        .sheet(isPresented: $showEditBranch) {
            NameEditView(presented: $showEditBranch, placeholder: "Page name...", title: "Edit Page name")
                .onSubmitName { name in
                    chatInt.editBranch(name: name, branch: branchContextMenu)
                }
        }
    }
}



/*
struct ChatsListView: View {
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @Binding var branchName: String
    
    @Binding var showBranchCreation: Bool
    
    @Binding var chatContextMenu: Chat
    
    @State var branchContextMenu: Branch = Branch()
    
    @State var showChatMenu: Bool = false
    
    @State var showChatDeleteAlert: Bool = false
    
    @State var showBranchDeleteAlert: Bool = false
    
    @State var showEditChat: Bool = false
    
    @State var showEditBranch: Bool = false
    
    var body: some View {
        List {
            ForEach(chatInt.chats) { chat in
                let expanded = chat.expanded ?? false
                FileRow(name: chat.name ?? "No name", folder: true, isExpanded: expanded)
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
                
                if expanded {
                    let branches = chat.branches ?? []
                    ForEach(branches) { branch in
                        NavLink(destination: BranchDetailScreen(branch: branch)
                        ) {
                            HStack {
                                FileRow(name: branch.name ?? "No name", folder: false, isExpanded: false)
                            }
                        }
                        .contextMenu {
                            Button("Rename Page") {
                                branchContextMenu = branch
                                showEditBranch = true
                            }
                            Button("Delete Page") {
                                branchContextMenu = branch
                                showBranchDeleteAlert = true
                            }
                        }
                        .alert(
                            "After hitting Delete this Page will be permanently deleted.",
                            isPresented: $showBranchDeleteAlert)
                        {
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                                chatInt.deleteBranch(branch: branchContextMenu)
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: [.top, .bottom])
            .listRowInsets(.init())
            .listRowBackground(Color.clear)
        }
        .sheet(isPresented: $showEditChat) {
            NameEditView(presented: $showEditChat, placeholder: "Folder name...", title: "Edit Folder name")
                .onSubmitName { name in
                    chatInt.editChat(name: name, chat: chatContextMenu)
                }
        }
        .sheet(isPresented: $showEditBranch) {
            NameEditView(presented: $showEditBranch, placeholder: "Page name...", title: "Edit Page name")
                .onSubmitName { name in
                    chatInt.editBranch(name: name, branch: branchContextMenu)
                }
        }
    }
}
*/

struct ChatsList_Previews: PreviewProvider {

    @State var branchName: String = ""

    static var previews: some View {
        ChatsListView(
            branchName: .constant(""),
            showBranchCreation: .constant(false),
            chatContextMenu: .constant(Chat()))
        .environmentObject(ChatInteractor.mock)
    }
}
