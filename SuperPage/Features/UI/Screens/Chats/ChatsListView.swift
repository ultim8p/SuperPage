//
//  ChatsScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation
import SwiftUI

struct ChatsListView: View {
    
    // MARK: Environment
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @EnvironmentObject var chatsState: ChatsState
    
    // MARK: Branch
    
    @Binding var branchName: String
    
    @Binding var showBranchCreation: Bool
    
    @Binding var chatContextMenu: Chat
    
    // MARK: Modals
    
    @State var branchContextMenu: Branch = Branch()
    
    @State var showChatMenu: Bool = false
    
    @State var showChatDeleteAlert: Bool = false
    
    @State var showBranchDeleteAlert: Bool = false
    
    @State var showEditChat: Bool = false
    
    @State var showEditBranch: Bool = false
    
    @State var swiftuisucksBranches = [Branch()]
    
    // MARK: Selection
    
    @Binding var selectedChat: Chat?
    
    var body: some View {
        ZStack {
            List(swiftuisucksBranches, selection: $navigationManager.selectedBranchRef) { _ in }
            
            AppColor.mainSecondary.color
                .ignoresSafeArea(.all)
            ScrollView {
                ForEach(chatsState.chats) { chat in
                    ChatRow(
                        chat: .constant(chat),
                        chatContextMenu: $chatContextMenu,
                        selectedChatId: $navigationManager.selectedChatId,
                        showEditChat: $showEditChat,
                        showChatDeleteAlert: $showChatDeleteAlert,
                        selectionHandler: {
                            self.handleChatRowSelection(chat: chat)
                        }
                    )
                    
                    if navigationManager.expandedChatIds.contains(chat.id) {
                        let branches = chatsState.branches[chat.id] ?? []
                        ForEach(branches) { branch in
                            BranchRow(
                                branch: .constant(branch),
                                selectedBranchRef: $navigationManager.selectedBranchRef,
                                branchContextMenu: $branchContextMenu,
                                showBranchDeleteAlert: $showBranchDeleteAlert,
                                editPressed: {
                                    navigationManager.editingBranch = branch
                                },
                                selectionHandler: {
                                    self.handleBranchRowSelection(chat: chat, branch: branch)
                                }
                            )
                        }
                    }
                }
            }
        }
        .clipped()
        .background(Color.homeBackground)
    }
}

extension ChatsListView {
    
    func handleChatRowSelection(chat: Chat) {
        withAnimation {
            navigationManager.toggleExpand(chatId: chat.id)
        }
        
        selectedChat = chat
        navigationManager.selectedChatId = chat.id
        
        if navigationManager.expandedChatIds.contains(chat.id) {
            chatsState.getBranches(chat: chat)
        }
    }
    
    func handleBranchRowSelection(chat: Chat, branch: Branch) {
        navigationManager.openBranch(branchId: branch.id, chatId: chat.id)
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
    }
}
*/

struct ChatsList_Previews: PreviewProvider {

    @State var branchName: String = ""

    static var previews: some View {
        ChatsListView(
            branchName: .constant(""),
            showBranchCreation: .constant(false),
            chatContextMenu: .constant(Chat()),
            selectedChat: .constant(nil)
        )
        .environmentObject(ChatsState.mock)
    }
}
