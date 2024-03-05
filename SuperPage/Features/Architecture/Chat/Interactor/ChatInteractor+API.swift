//
//  ChatInteractor+API.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

// MARK: - Chat

extension ChatInteractor {
    
    // MARK: GET
    
    func reloadChats() {
        Task {
            do {
                let response = try await repo.getChatsAllMe(env: env)
                self.chats = response.items ?? []
                self.loadingChatsState = .ok
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
        setState(chat: chat, state: .loading)
        Task {
            do {
                let request = Chat(_id: chat._id, name: name)
                let result = try await repo.editChat(env: env, chat: request)
                setState(chat: chat, state: .ok)
                guard result.result == .ok else { return }
                setChat(name: name, chat: chat)
            } catch {
                setState(chat: chat, state: .error(error))
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

extension ChatInteractor {
    
    // MARK: GET
    
    func getBranches(chat: Chat) {
        let chatRequest = Chat(_id: chat.id)
        setState(chat: chat, state: .loading)
        Task {
            do {
                let response = try await repo.getChatsBranchesAllMe(env: env, chat: chatRequest)
                setState(chat: chat, state: .ok)
                guard let items = response.items else { return }
                setBranches(response: items)
            }
            catch {
                setState(chat: chat, state: .error(error))
            }
        }
    }
    
    // MARK: POST
    
    func createBranch(name: String?, promptRole: Role?, chat: Chat, handler: ((_ id: String) -> Void)? = nil) {
        setState(chat: chat, state: .loading)
        Task {
            do {
                let branchRequest = Branch(chat: chat, promptRole: promptRole, name: name)
                let response = try await repo.postChatsBranchesCreate(env: env, branch: branchRequest)
                setState(chat: chat, state: .ok)
                addBranch(response)
                handler?(response.id)
            }
            catch {
                setState(chat: chat, state: .error(error))
            }
        }
    }
    
    func editBranch(branch: Branch, name: String?, promptRole: Role?) {
        setState(branch: branch, loadingState: .loading)
        Task {
            do {
                let request = Branch(_id: branch._id, promptRole: promptRole, name: name)
                let updatedBranch = try await repo.editBranch(env: env, branch: request)
                setState(branch: branch, loadingState: .ok)
//
                updateBranch(branch: updatedBranch)
            } catch {
                setState(branch: branch, state: .ok)
            }
        }
    }
    
    // MARK: DELETE
    
    func deleteBranch(branch: Branch) {
        setState(chatId: branch.chat?._id, state: .loading)
        Task {
            do {
                let response = try await repo.deleteBranch(env: env, branch: branch)
                setState(chatId: branch.chat?._id, state: .ok)
                guard response.result == .ok else { return }
                remove(branch: branch)
            } catch {
                setState(chatId: branch.chat?._id, state: .error(error))
            }
        }
    }
}

// MARK: - Message

extension ChatInteractor {
    
    // MARK: GET
    
    func getMessages(branch: Branch) {
        setState(branch: branch, loadingState: .loading)
        Task {
            do {
                let branchRequest = Branch(_id: branch._id)
                let response = try await repo.getChatsBranchesMessagesAllMe(env: env, branch: branchRequest)
                setState(branch: branch, loadingState: .ok)
                guard let messages = response.items else { return }
                setMessages(messages: messages, branch: branch)
            }
            catch {
                setState(branch: branch, loadingState: .ok)
                print("LOADING MESSAGES ERROR: \(error)")
            }
        }
    }
    
    // MARK: DELETE
    
    func deleteMessage(message: Message) {
        setState(branch: message.branch, loadingState: .loading)
        Task {
            do {
                let response = try await repo.deleteMessage(env: env, message: message)
                setState(branch: message.branch, loadingState: .ok)
                guard response.result == .ok else { return }
                removeMessage(message: message)
            } catch {
                setState(branch: message.branch, loadingState: .ok)
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
        setState(branch: branch, state: .creatingMessage, loadingState: .loading)
        save(draft: draft)
        Task {
            do {
                let response = try await repo.postChatsBranchesMessagesCreate(env: env, reques: request)
                guard let messages = response.items, !messages.isEmpty else {
                    setState(branch: branch, state: .ok, loadingState: .ok)
                    return
                }
                
                deleteDraft(branchId: branch._id)
                setState(branch: branch, state: .ok, loadingState: .ok)
                setError(branch: branch, createMessageError: nil)
                addMessage(messages: messages, branch: branch)
                
                settingsInt.reloadSetttings()
            }  catch let error as NoError {
                setState(branch: branch, state: .ok, loadingState: .ok)
                setError(branch: branch, createMessageError: error)
            } catch {
                setState(branch: branch, state: .ok , loadingState: .error(error))
            }
        }
    }
}

// MARK: - Draft

extension ChatInteractor {
    
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
