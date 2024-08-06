//
//  HomeSheets.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/24/24.
//

import SwiftUI

struct RootSheetsModifier: ViewModifier {
    
    @EnvironmentObject var chatsState: ChatsState
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    func body(content: Content) -> some View {
        content
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
                            chatsState.editBranch(branch: branch, name: name, promptRole: role)
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
                            chatsState.createBranch(name: name, promptRole: role, chat: chat) { id in
                                navigationManager.openBranch(branchId: id, chatId: chat.id)
                            }
                        }
                }
            )
        
            .sheet(item: $navigationManager.creatingChat) { chat in
                ChatCreateView { name in
                    chatsState.createChat(name: name) { chatId in
                        navigationManager.selectedChatId = chatId
                        navigationManager.expand(chatId: chatId)
                    }
                }
            }
            
            .sheet(item: $navigationManager.editingChat, onDismiss: {}) { chat in
                ChatEditView(name: chat.name ?? "") { name in
                    chatsState.editChat(name: name, chat: chat)
                }
            }
            .sheet(isPresented: $navigationManager.sheetSettings, content: {
                SettingsScreen()
            })
        
            .sheet(isPresented: $navigationManager.sheetUpgrade, content: {
                UpgradeScreen()
            })
        
            .sheet(isPresented: $navigationManager.sheetTokenStore, content: {
                TokenStoreScreen()
            })
    }
}

extension View {
    
    func rootSheetsModifier() -> some View {
        modifier(RootSheetsModifier())
    }
}
