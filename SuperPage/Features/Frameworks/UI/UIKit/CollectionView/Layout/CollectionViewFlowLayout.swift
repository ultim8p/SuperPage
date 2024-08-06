//
//  CollectionViewFlowLayout.swift
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

class CollectionViewFlowLayout: PlatformCollectionViewFlowLayout {
    
    var totalHeights: [Int: CGFloat] = [:]
    
    func totalHeight(for sections: [Int]) -> CGFloat {
        var height: CGFloat = 0.0

        for section in sections {
            height += totalHeights[section] ?? 0.0
        }

        return height
    }
    
    override init() {
        super.init()
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        self.totalHeights = [:]
    }
    
    #if os(macOS)
    override func layoutAttributesForElements(in rect: CGRect) -> [PlatformCollectionViewLayoutAttributes] {
        noLayoutAttributesForItems(in: rect)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> PlatformCollectionViewLayoutAttributes? {
        noLayoutAttributesForItem(at: indexPath)
    }
    #elseif os(iOS)
    override func layoutAttributesForElements(in rect: CGRect) -> [PlatformCollectionViewLayoutAttributes]? {
        noLayoutAttributesForItems(in: rect)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> PlatformCollectionViewLayoutAttributes? {
        noLayoutAttributesForItem(at: indexPath)
    }
    #endif
    private func noLayoutAttributesForItems(in rect: CGRect) -> [PlatformCollectionViewLayoutAttributes] {
    #if os(macOS)
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
    #elseif os(iOS)
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
    #endif
        for attribute in layoutAttributes {
        #if os(macOS)
            guard let section = attribute.indexPath?.section else { continue }
        #elseif os(iOS)
            let section = attribute.indexPath.section
        #endif
            totalHeights[section] = (totalHeights[section] ?? 0) + attribute.frame.size.height
        }
        return layoutAttributes
    }
    private func noLayoutAttributesForItem(at indexPath: IndexPath) -> PlatformCollectionViewLayoutAttributes? {
        let layoutAttribute = super.layoutAttributesForItem(at: indexPath)
        if let height = layoutAttribute?.frame.size.height {
            let section = indexPath.section
            totalHeights[section] = (totalHeights[section] ?? 0) + height
        }
        return layoutAttribute
    }
}
