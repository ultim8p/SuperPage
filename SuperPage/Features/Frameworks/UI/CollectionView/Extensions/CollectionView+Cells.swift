//
//  CollectionView+Cells.swift
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

extension PlatformCollectionView {
    
    func noRegisterCell<T: PlatformCollectionViewCell & ClassNameProtocol>(cell: T.Type) {
    #if os(macOS)
        register(T.self, forItemWithIdentifier: T.userInterfaceItemIdentifier)
    #elseif os(iOS)
        register(T.self, forCellWithReuseIdentifier: T.className)
    #endif
    }

    func noReusableCell<T: PlatformCollectionViewCell & ClassNameProtocol>(for indexPath: IndexPath) -> T {
    #if os(macOS)
        guard let cell = makeItem(
            withIdentifier: T.userInterfaceItemIdentifier,
            for: indexPath) as? T
        else { fatalError("Unable to Dequeue Reusable Cell") }
        return cell
    #elseif os(iOS)
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.className,
            for: indexPath) as? T
        else { fatalError("Unable to Dequeue Reusable Cell") }

        return cell
    #endif
    }
}
