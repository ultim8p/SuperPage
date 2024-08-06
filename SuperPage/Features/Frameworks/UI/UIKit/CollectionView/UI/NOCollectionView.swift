//
//  NOCollectionView.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/12/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

class NOCollectionView: PlatformCollectionView {
    
    var collectionLayout = CollectionViewFlowLayout()
    
    init() {
    #if os(macOS)
        super.init(frame: .zero)
        collectionViewLayout = collectionLayout
        isSelectable = false
        allowsMultipleSelection = false
        backgroundColors = [.clear]
    #elseif os(iOS)
        super.init(frame: .zero, collectionViewLayout: collectionLayout)
        backgroundColor = .clear
        alwaysBounceVertical = true
        keyboardDismissMode = .interactive
    #endif
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if os(macOS)
//    override var frame: PlatformRect {
//      didSet {
//        collectionViewLayout?.invalidateLayout()
//      }
//    }
    #endif
    
    var collectionHeight: CGFloat {
    #if os(macOS)
        return enclosingScrollView?.frame.size.height ?? 0.0
    #elseif os(iOS)
        return frame.size.height
    #endif
    }
    
    var noVisibleCells: [PCollectionViewCell] {
#if os(macOS)
        return visibleItems()
#elseif os(iOS)
        return visibleCells
#endif
    }
}
