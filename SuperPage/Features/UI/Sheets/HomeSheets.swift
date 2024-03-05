//
//  HomeSheets.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/24/24.
//

import SwiftUI

struct RootSheetsModifier: ViewModifier {
    
    @EnvironmentObject var chatInt: ChatInteractor
    
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
                            chatInt.createBranch(name: name, promptRole: role, chat: chat) { id in
                                navigationManager.openBranch(id: id)
                            }
                        }
                }
            )
        
            .sheet(item: $navigationManager.creatingChat) { chat in
                ChatCreateView { name in
                    chatInt.createChat(name: name) { chatId in
                        navigationManager.selectedChatId = chatId
                        chatInt.expandChat(with: chatId)
                    }
                }
            }
            
            .sheet(item: $navigationManager.editingChat, onDismiss: {}) { chat in
                ChatEditView(name: chat.name ?? "") { name in
                    chatInt.editChat(name: name, chat: chat)
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
