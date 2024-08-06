//
//  BranchReference.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct BranchReference: Codable, Equatable, Hashable {
    
    var _id: String?
    
    var chat: ChatReference?
}

extension BranchReference {
    
    static func create(branchId: String, chatId: String) -> BranchReference {
        BranchReference(
            _id: branchId,
            chat: ChatReference(_id: chatId)
        )
    }
}
