//
//  ChatsState+Mock.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

extension ChatsState {
    
    static var mock: ChatsState {
        let interactor = ChatsState()
//        interactor.chats = [
//            Chat(name: "Chat1"),
//            Chat(name: "Chat3",
//                 branches: [
//                    Branch(name: "Branch 1"),
//                    Branch(name: "Branch 2"),
//                    Branch(name: "Branch 3")
//                 ]),
//            Chat(name: "Chat4"),
//            Chat(name: "Chat5", branches: [Branch(name: "Branch1")])
//        ]
        return interactor
    }
}
