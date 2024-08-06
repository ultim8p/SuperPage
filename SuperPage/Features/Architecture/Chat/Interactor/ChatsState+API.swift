//
//  ChatsState+API.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

// MARK: - Chat


extension ChatsState {
    
    // MARK: GET
    
    func reloadChats() {
        Task(priority: .userInitiated) { @MainActor in
            do {
                let response = try await repo.getChatsAllMe(env: env)
                await MainActor.run {
                    self.chats = response.items ?? []
                    self.loadingChatsState = .ok
                    
                }
            } catch {
                print("CHAT ERR: \(error)")
                self.loadingChatsState = .error(error)
            }
        }
    }
    
    // MARK: POST
    
    func createChat(name: String?, handler: ((_ chatId: String) -> Void)? = nil) {
        Task {
            do {
                let chat = try await repo.postChatsCreate(env: env, chat: Chat(name: name))
                chats.append(chat)
                handler?(chat.id)
            } catch {
                print("CREATE CHAT ERR: \(error)")
            }
        }
    }
    
    func editChat(name: String, chat: Chat) {
        update(chat: chat, localState: .loading)
        Task {
            do {
                let request = Chat(_id: chat._id, name: name)
                let result = try await repo.editChat(env: env, chat: request)
                update(chat: chat, localState: .ok)
                guard result.result == .ok else { return }
                update(chat: chat, name: name)
            } catch {
                update(chat: chat, localState: .error(error))
                print("EDIT CHAT ERR: \(error)")
            }
        }
    }
    
    // MARK: DELETE
    
    func deleteChat(chat: Chat) {
        Task {
            do {
                let response = try await repo.deleteChat(env: env, chat: chat)
                guard response.result == .ok else { return }
                remove(chat: chat)
            } catch {
                print("DELETE CHAT ERR: \(error)")
            }
        }
    }
}

// MARK: - Branch

extension ChatsState {
    
    // MARK: GET
    
    func getBranches(chat: Chat) {
        let chatRequest = Chat(_id: chat.id)
        update(chat: chat, localState: .loading)
        Task {
            do {
                let response = try await repo.getChatsBranchesAllMe(env: env, chat: chatRequest)
                update(chat: chat, localState: .ok)
                guard let items = response.items else { return }
                setBranches(response: items)
            }
            catch {
                update(chat: chat, localState: .error(error))
            }
        }
    }
    
    // MARK: POST
    
    func createBranch(name: String?, promptRole: Role?, chat: Chat, handler: ((_ id: String) -> Void)? = nil) {
        update(chat: chat, localState: .loading)
        Task {
            do {
                let branchRequest = Branch(chat: chat, promptRole: promptRole, name: name)
                let response = try await repo.postChatsBranchesCreate(env: env, branch: branchRequest)
                update(chat: chat, localState: .ok)
                addBranch(response)
                handler?(response.id)
            }
            catch {
                update(chat: chat, localState: .error(error))
            }
        }
    }
    
    func editBranch(branch: Branch, name: String?, promptRole: Role?) {
        update(branch: branch, localState: .loading)
        Task {
            do {
                let request = Branch(_id: branch._id, promptRole: promptRole, name: name)
                let updatedBranch = try await repo.editBranch(env: env, branch: request)
                update(branch: branch, localState: .ok)
                updateBranch(branch: updatedBranch)
            } catch {
                update(branch: branch, localState: .ok)
            }
        }
    }
    
    // MARK: DELETE
    
    func deleteBranch(branch: Branch) {
        update(chatId: branch.chat?._id, localState: .loading)
        Task {
            do {
                let response = try await repo.deleteBranch(env: env, branch: branch)
                update(chatId: branch.chat?._id, localState: .ok)
                guard response.result == .ok else { return }
                remove(branch: branch)
            } catch {
                update(chatId: branch.chat?._id, localState: .ok)
            }
        }
    }
}

// MARK: - Message

extension ChatsState {
    
    // MARK: GET
    
    func getMessages(branch: Branch) {
        update(branch: branch, localState: .loading)
        Task {
            do {
                let branchRequest = Branch(_id: branch._id)
                let response = try await repo.getChatsBranchesMessagesAllMe(env: env, branch: branchRequest)
                update(branch: branch, localState: .ok)
                guard let messages = response.items else { return }
                setMessages(messages: messages, branch: branch)
            } catch {
                update(branch: branch, localState: .ok)
                print("LOADING MESSAGES ERROR: \(error)")
            }
        }
    }
    
    // MARK: DELETE
    
    func deleteMessage(message: Message) {
        update(branch: message.branch, localState: .loading)
        Task {
            do {
                let response = try await repo.deleteMessage(env: env, message: message)
                update(branch: message.branch, localState: .ok)
                guard response.result == .ok else { return }
                removeMessage(message: message)
            } catch {
                update(branch: message.branch, localState: .ok)
                print("DELETE CHAT ERR: \(error)")
            }
        }
    }
    
    // MARK: POST
    
    func postCreateMessage(
        text: String,
        model: AIModel,
        branch: Branch,
        messageIds: [String]?
    ) {
//        let system: String? = systemMessage.isEmpty ? nil : systemMessage
        let context = MessagesCreateRequestContext(
            messageIds: messageIds
        )
        var request = MessagesCreateRequest(context: context)
        let creatingMessage = Message.create(role: .user, text: text)
        request.messages = [creatingMessage]
        request.model = model
        request.branch = BranchReference(_id: branch._id)
        
        let draft = MessageDraft(
            branch: Branch(_id: branch._id),
            messages: [
                Message.create(role: .user, text: text)
            ]
        )
//        setState(branch: branch, state: .creatingMessage, loadingState: .loading)
        update(branch: branch, state: .creatingMessage)
        update(branch: branch, localState: .loading)
        
        save(draft: draft)
        Task {
            do {
                let response = try await repo.postChatsBranchesMessagesCreate(env: env, reques: request)
                guard let messages = response.items, !messages.isEmpty else {
                    update(branch: branch, state: .ok)
                    update(branch: branch, localState: .ok)
                    return
                }
                
                deleteDraft(branchId: branch._id)
                
                update(branch: branch, state: .ok)
                update(branch: branch, localState: .ok)
                update(branch: branch, createMessageError: nil)
                addMessage(messages: messages, branch: branch)
                
                settings.reloadSetttings()
            }  catch let error as NoError {
                update(branch: branch, state: .ok)
                update(branch: branch, localState: .ok)
                update(branch: branch, createMessageError: error)
            } catch {
                update(branch: branch, state: .ok)
                update(branch: branch, localState: .error(error))
            }
        }
    }
}

// MARK: - Draft

extension ChatsState {
    
    func getDraft(branch: Branch) {
        let request = Branch(_id: branch._id)
        Task {
            do {
                let draft = try await repo.getMessageDraftsBranch(env: env, branch: request)
                save(draft: draft)
            } catch { }
        }
    }
}
