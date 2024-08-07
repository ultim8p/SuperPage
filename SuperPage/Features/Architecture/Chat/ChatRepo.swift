//
//  ChatRepo.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation
import NoAPI

enum ChatPath: APIPath {
    
    case getChatsAllMe
    
    case getChatsBranchesAllMe
    
    case getChatsBranchesMessagesAllMe
    
    case postChatsCreate
    
    case postChatsBranchesCreate
    
    case postChatsBranchesMessagesCreate
    
    case deleteChat
    
    case deleteBranch
    
    case deleteMessage
    
    case postChatEdit
    
    case postBranchEdit
    
    case getMessageDraftsBranch
    
    var description: String {
        switch self {
        case .getChatsAllMe:
            return "/v1/chats/all/me"
        case .getChatsBranchesAllMe:
            return "/v1/chats/branches/all/me"
        case .getChatsBranchesMessagesAllMe:
            return "/v1/chats/branches/messages/all/me"
        case .postChatsCreate:
            return "/v1/chats/create"
        case .postChatsBranchesCreate:
            return "/v1/chats/branches/create"
        case .postChatsBranchesMessagesCreate:
            return "/v1/chats/branches/messages/create"
        case .deleteChat:
            return "/v1/chats/delete"
        case .deleteBranch:
            return "/v1/branches/delete"
        case .deleteMessage:
            return "/v1/messages/delete"
        case .postChatEdit:
            return "/v1/chats/edit"
        case .postBranchEdit:
            return "/v1/branches/edit"
        case .getMessageDraftsBranch:
            return "/v1/messagedrafts/branch"
        }
    }
}

class ChatRepo {
    
    // MARK: - GET
    
    func getChatsAllMe(env: EnvironmentState)
    async throws -> ListResponse<Chat> {
        return try await .get(
            env,
            path: ChatPath.getChatsAllMe,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
    
    func getChatsBranchesAllMe(env: EnvironmentState, chat: Chat)
    async throws -> ListResponse<Branch> {
        return try await chat.request(
            env,
            method: .get,
            path: ChatPath.getChatsBranchesAllMe,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
    
    func getChatsBranchesMessagesAllMe(env: EnvironmentState, branch: Branch)
    async throws -> ListResponse<Message> {
        return try await branch.request(
            env,
            method:. get,
            path: ChatPath.getChatsBranchesMessagesAllMe,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
    
    func getMessageDraftsBranch(env: EnvironmentState, branch: Branch) async throws -> MessageDraft {
        return try await branch.request(
            env, 
            method: .get,
            path: ChatPath.getMessageDraftsBranch,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
    
    // MARK: - POST
    
    func postChatsCreate(env: EnvironmentState, chat: Chat)
    async throws -> Chat {
        return try await chat.request(
            env,
            method: .post,
            path: ChatPath.postChatsCreate,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
    
    func postChatsBranchesCreate(env: EnvironmentState, branch: Branch)
    async throws -> Branch {
        return try await branch.request(
            env,
            method: .post,
            path: ChatPath.postChatsBranchesCreate,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
    
    func postChatsBranchesMessagesCreate(env: EnvironmentState, reques: MessagesCreateRequest)
    async throws -> ListResponse<Message> {
        return try await reques.request(
            env,
            method: .post,
            path: ChatPath.postChatsBranchesMessagesCreate,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
    
    func deleteChat(env: EnvironmentState, chat: Chat) async throws -> EmptyResponse {
        let chatRequest = Chat(_id: chat._id)
        return try await chatRequest.request(
            env,
            method: .delete,
            path: ChatPath.deleteChat,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
    
    func deleteBranch(env: EnvironmentState, branch: Branch) async throws -> EmptyResponse {
        let branchRequest = Branch(_id: branch._id)
        return try await branchRequest.request(
            env,
            method: .delete,
            path: ChatPath.deleteBranch,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
    
    func deleteMessage(env: EnvironmentState, message: Message) async throws -> EmptyResponse {
        let messageRequest = Message(_id: message._id)
        return try await messageRequest.request(
            env,
            method: .delete,
            path: ChatPath.deleteMessage,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
    
    func editChat(env: EnvironmentState, chat: Chat) async throws -> EmptyResponse {
        let request = Chat(_id: chat._id, name: chat.name)
        return try await request.request(
            env,
            method: .post,
            path: ChatPath.postChatEdit,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
    
    func editBranch(env: EnvironmentState, branch: Branch) async throws -> Branch {
        let request = Branch(_id: branch._id, promptRole: branch.promptRole, name: branch.name)
        return try await request.request(
            env,
            method: .post,
            path: ChatPath.postBranchEdit,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env)
        .responseValue()
    }
}
