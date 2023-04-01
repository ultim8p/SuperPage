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
        }
    }
}

class ChatRepo {
    
    // MARK: - GET
    
    func getChatsAllMe(env: EnvironmentInteractor)
    async throws -> ListResponse<Chat> {
        return try await .get(env, path: ChatPath.getChatsAllMe)
            .authenticate(env: env)
            .responseValue()
    }
    
    func getChatsBranchesAllMe(env: EnvironmentInteractor, chat: Chat)
    async throws -> ListResponse<Branch> {
        return try await chat.request(env, method: .get, path: ChatPath.getChatsBranchesAllMe)
            .authenticate(env: env)
            .responseValue()
    }
    
    func getChatsBranchesMessagesAllMe(env: EnvironmentInteractor, branch: Branch)
    async throws -> ListResponse<Message> {
        return try await branch.request(env, method:. get, path: ChatPath.getChatsBranchesMessagesAllMe)
            .authenticate(env: env)
            .responseValue()
    }
    
    // MARK: - POST
    
    func postChatsCreate(env: EnvironmentInteractor, chat: Chat)
    async throws -> Chat {
        return try await chat.request(env, method: .post, path: ChatPath.postChatsCreate)
            .authenticate(env: env)
            .responseValue()
    }
    
    func postChatsBranchesCreate(env: EnvironmentInteractor, branch: Branch)
    async throws -> Branch {
        return try await branch.request(env, method: .post, path: ChatPath.postChatsBranchesCreate)
            .authenticate(env: env)
            .responseValue()
    }
    
    func postChatsBranchesMessagesCreate(env: EnvironmentInteractor, reques: MessagesCreateRequest)
    async throws -> ListResponse<Message> {
        return try await reques.request(env, method: .post, path: ChatPath.postChatsBranchesMessagesCreate)
            .authenticate(env: env)
            .responseValue()
    }
}
