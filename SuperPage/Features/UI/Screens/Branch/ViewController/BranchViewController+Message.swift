//
//  BranchViewController+Message.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/13/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

extension BranchViewController {
    
    /*
    func sendNewMessage() {
        guard !newMessage.isEmpty, let branch else { return }
        
        let draftMessage = Message.create(role: .user, text: newMessage)
        draft = MessageDraft(branch: branch, messages: [draftMessage])
        
        chatInteractor.postCreateMessage(
            text: newMessage,
            model: localModel,
            branch: branch,
            messageIds: Array(selectedMessagesIds.keys)
        )
        

        
        
        newMessage = ""
        collectionView.collectionLayout.invalidateLayout()
        reloadCells()
        updateCollectionLayoutForMessage(isNew: true)
    }
    */
    
    //        let placeholderMessage = Message(role: .user, text: newMessage)
    //        messages.append(placeholderMessage)
    //        appendCellHeightFor(message: placeholderMessage)
}
