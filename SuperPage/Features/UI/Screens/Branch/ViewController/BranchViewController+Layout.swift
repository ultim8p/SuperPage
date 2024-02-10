//
//  BranchViewController+Delegate.swift
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
    
    func item(at indexPath: IndexPath) -> Message? {
        guard indexPath.item < messages.count else { return nil }
        return messages[indexPath.item]
    }
    
    func configure(cell: MessageCell, for indexPath: IndexPath) {
        let item = item(at: indexPath)
        cell.configure(
            message: item,
            editable: false,
            width: view.bounds.size.width,
            isSelected: isSelected(message: item)
        )
        cell.delegate = self
    }
    
    func cellItem(at indexPath: IndexPath) -> PCollectionViewCell {
        switch Sections(rawValue: indexPath.section)! {
        case .messages:
            let cell: MessageCell = collectionView.noReusableCell(for: indexPath)
            configure(cell: cell, for: indexPath)
            return cell
        case .drafts:
            let cell: MessageCell = collectionView.noReusableCell(for: indexPath)
            cell.configure(
                text: draft?.messages?.first?.content?.first?.texts?.first ?? "",
                editable: false,
                width: view.bounds.size.width,
                showSeparator: true
            )
            return cell
        case .loading:
            let cell: LoadingCell = collectionView.noReusableCell(for: indexPath)
            return cell
        case .newMessage:
            let cell: MessageCell = collectionView.noReusableCell(for: indexPath)
            cell.configure(
                text: newMessage,
                editable: !isLoading,
                width: view.bounds.size.width,
                showSeparator: hasMessages)
            cell.delegate = self
            return cell
        }
    }
    
    func sizeForItem(at indexPath: IndexPath) -> NOSize {
        switch Sections(rawValue: indexPath.section)! {
        case .messages:
            guard indexPath.item < messageCellHeights.count else {
                return NOSize(width: collectionView.bounds.size.width, height: 0.0)
            }
            let cellHeight = messageCellHeights[indexPath.item]
            return NOSize(width: collectionView.bounds.size.width, height: cellHeight)
        case .drafts:
            guard let draftText = draft?.messages?.first?.fullTextValue() else {
                return NOSize(width: collectionView.bounds.size.width, height: 0.0)
            }
            staticTextView.noSetText(text: draftText)
            let textSize = staticTextView.targetTextSize(targetWidth: textWidth)
            let textHeight = textSize.height + MessageCell.Constant.topSpace + MessageCell.Constant.bottomSpace
            return NOSize(width: collectionView.bounds.size.width, height: textHeight)
        case .loading:
            return NOSize(width: collectionView.bounds.size.width, height: Constant.loadingHeight)
        case .newMessage:
            let item = newMessage
            staticTextView.noSetText(text: item)
            let textSize = staticTextView.targetTextSize(targetWidth: textWidth)
            let textHeight = textSize.height + MessageCell.Constant.topSpace + MessageCell.Constant.bottomSpace
            
            var cellHeight = 0.0
            
            let cellHeights = totalMessagesHeights + (CGFloat(loadingSectionCount()) * Constant.loadingHeight)
            
            let cvHeight = collectionView.collectionHeight
            if cellHeights < cvHeight {
                cellHeight = cvHeight - cellHeights
            }
            
            cellHeight = max(textHeight, max(Constant.minimumNewMessageHeight, cellHeight))
            
            let cellSize = NOSize(width: collectionView.bounds.size.width, height: cellHeight)
            return cellSize
        }
    }
}

extension BranchViewController: PlatformCollectionViewDatasource, PlatformCollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: PlatformCollectionView) -> Int {
        return Sections.allCases.count
    }
    
    func collectionView(_ collectionView: PlatformCollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .messages:
            return messagesCount()
        case .drafts:
            return draftSectionCount()
        case .loading:
            return loadingSectionCount()
        case .newMessage:
            return newMessageCount()
        }
    }
    
    #if os(macOS)
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return cellItem(at: indexPath)
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> NOSize {
        return sizeForItem(at: indexPath)
    }
    
    #elseif os(iOS)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NOSize {
        return sizeForItem(at: indexPath)
    }
    #endif
}
