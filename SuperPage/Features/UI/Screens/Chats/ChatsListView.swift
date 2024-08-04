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
            List(swiftuisucksBranches, selection: $navigationManager.selectedBranchId) { _ in }
            
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
                            withAnimation {
                                selectedChat = chat
                                navigationManager.selectedChatId = chat.id
                                chatsState.toggleExpand(chat: chat)
                            }
                        }
                    )
                    
                    if chat.expanded ?? false {
                        ForEach(chat.branches ?? []) { branch in
                            BranchRow(
                                branch: .constant(branch),
                                selectedBranchId: $navigationManager.selectedBranchId,
                                branchContextMenu: $branchContextMenu,
                                showBranchDeleteAlert: $showBranchDeleteAlert,
                                editPressed: {
                                    navigationManager.editingBranch = branch
                                },
                                selectionHandler: {
                                    print("DID SELECT BRANCH: \(branch.id)")
                                    //                                    navigationManager.selectedBranchId = branch.id
                                    navigationManager.openBranch(id: branch.id)
                                }
                            )
                            
                        }
                    }
                }
            }
        }
        .clipped()
        .background(Color.homeBackground)
        .onChange(of: chatsState.chats) { oldValue, newValue in
            print("Up´dated chats: \(oldValue.count) New val: \(newValue.count)")
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
