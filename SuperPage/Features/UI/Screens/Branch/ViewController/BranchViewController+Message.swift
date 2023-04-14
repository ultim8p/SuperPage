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
    
    func sendNewMessage() {
        guard !newMessage.isEmpty else { return }
        sendMessageHandler?(newMessage)
        
        isLoading = true
        
        let placeholderMessage = Message(role: .user, text: newMessage)
        localMessages.append(placeholderMessage)
        newMessage = ""
        appendCellHeightFor(message: placeholderMessage)
        collectionView.collectionLayout.invalidateLayout()
        reloadCells()
        updateCollectionLayoutForMessage(isNew: true)
    }
}
