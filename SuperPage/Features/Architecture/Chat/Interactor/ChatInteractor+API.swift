//
//  ChatInteractor+API.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

extension ChatInteractor {
    
    // MARK: - GET
    
    func reloadChats() {
        Task {
            do {
                let response = try await repo.getChatsAllMe(env: env)
                self.chats = response.items ?? []
            } catch {
                print("CHAT ERR: \(error)")
            }
        }
    }
    
    func getBranches(chat: Chat) {
        let chatRequest = Chat(_id: chat.id)
        Task {
            do {
                let response = try await repo.getChatsBranchesAllMe(env: env, chat: chatRequest)
                guard let items = response.items else{ return }
                self.setBranches(response: items, for: chat)
            }
            catch {
                print("GET BRANCHS ERR: \(error)")
            }
        }
    }
    
    func getMessages(branch: Branch) {
        Task {
            do {
                let branchRequest = Branch(_id: branch._id)
                let response = try await repo.getChatsBranchesMessagesAllMe(env: env, branch: branchRequest)
                guard branch._id == response.items?.first?.branch?._id else { return }
                guard let messages = response.items else { return }
                self.messages = messages
            }
            catch {
                print("GET MESSGS ERR: \(error)")
            }
        }
    }
    
    // MARK: - POST
    
    func createBranch(name: String?, chat: Chat) {
        Task {
            do {
                let branchRequest = Branch(chat: chat, name: name)
                let response = try await repo.postChatsBranchesCreate(env: env, branch: branchRequest)
                addBranch(response: response, to: chat)
            }
            catch {
                print("CREATE BRANCH ERR: \(error)")
            }
        }
    }
    
    func createChat(name: String?) {
        Task {
            do {
                let chat = try await repo.postChatsCreate(env: env, chat: Chat(name: name))
                chats.append(chat)
            } catch {
                print("CREATE CHAT ERR: \(error)")
            }
        }
    }
    
    func postCreateMessage(text: String, branch: Branch, independentMessages: Bool, systemMessage: String) {
        let system: String? = systemMessage.isEmpty ? nil : systemMessage
        let context = MessagesCreateRequestContext(
            branch: BranchReference(_id: branch._id),
            systemMessage: system,
            useBranch: !independentMessages)
        var request = MessagesCreateRequest(context: context)
        request.messages = [Message(role: .user, text: text)]
        request.model = .gpt35turbo
        Task {
            do {
                let response = try await repo.postChatsBranchesMessagesCreate(env: env, reques: request)
                messages.append(contentsOf: response.items ?? [])
            } catch {
                print("CREATE MESSAGE ERR: \(error)")
            }
        }
    }
    
    func addBranch(response: Branch, to chat: Chat) {
        var chats = self.chats
        guard let chatIndex = chats.firstIndex(where: { $0._id == chat._id }) else { return }
        var updatingChat = chats[chatIndex]
        var branches = updatingChat.branches ?? []
        
        branches.append(response)
        
        updatingChat.branches = branches
        chats[chatIndex] = updatingChat
        self.chats = chats
    }
    
    func setBranches(response: [Branch], for chat: Chat) {
        var chats = self.chats
        guard let chatIndex = chats.firstIndex(where: { $0._id == chat._id }) else { return }
        var updatingChat = chats[chatIndex]
        updatingChat.branches = response
        chats[chatIndex] = updatingChat
        self.chats = chats
    }
}
