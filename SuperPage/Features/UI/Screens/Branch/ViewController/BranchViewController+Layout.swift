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

extension BranchViewController: PlatformCollectionViewDatasource, PlatformCollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: PlatformCollectionView) -> Int {
        return Sections.allCases.count
    }
    
    func collectionView(_ collectionView: PlatformCollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .messages:
            return messagesCount()
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
    ) -> PlatformSize {
        return sizeForItem(at: indexPath)
    }
    
    #elseif os(iOS)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> PlatformSize {
        return sizeForItem(at: indexPath)
    }
    #endif
}
