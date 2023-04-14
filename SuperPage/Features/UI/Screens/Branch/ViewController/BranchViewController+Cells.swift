//
//  BranchViewController+Cells.swift
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

extension BranchViewController: MessageCellDelegate {
    
    func messageCell(_ item: MessageCell, didPerform shortcut: KeyboardShortcut) {
        switch shortcut {
        case .commandEnter:
            sendNewMessage()
        default:
            break
        }
    }
    
    func messageCellWillUpdateMessage(_ item: MessageCell) {
        wasScrolledToBottom = collectionView.isScrolledToBottom()
    }
    
    func messageCell(_ item: MessageCell, didUpdateMessage message: String) {
        guard let indexPath = collectionView.indexPath(for: item) else { return }
        switch Sections(rawValue: indexPath.section)! {
        case .messages:
            localMessages[indexPath.item].text = message
            updateCollectionLayoutForMessage(isNew: false)
        case .newMessage:
            newMessage = message
            updateCollectionLayoutForMessage(isNew: false)
        default:
            break
        }
    }
    
    func updateCollectionLayoutForMessage(isNew: Bool) {
        collectionView.collectionLayout.invalidateLayout()
        view.reloadLayoutIfNeeded()
        if wasScrolledToBottom || isNew {
            collectionView.scrollToBottom(animated: isNew)
        }
    }
}
