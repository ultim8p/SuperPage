//
//  ChatInteractor.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation
import SwiftUI

class ChatInteractor: ObservableObject {
    
    let repo: ChatRepo
    
    @Published var chats: [Chat] = []
    
    @Published var branches: [Branch] = []
    
    @Published var branch: Branch?
    
    @Published var messages: [Message] = []
    
    @ObservedObject var env: EnvironmentInteractor
    
    init(repo: ChatRepo) {
        self.repo = repo
        env = EnvironmentInteractor.mock
    }
    
    func inject(env: EnvironmentInteractor) {
        self.env = env
    }
}
