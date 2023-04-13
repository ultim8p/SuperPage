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
    
    var totalItemHeight: CGFloat = 0
    
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
        self.totalItemHeight = 0
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
            self.totalItemHeight += attribute.frame.size.height
        }
        return layoutAttributes
    }
    private func noLayoutAttributesForItem(at indexPath: IndexPath) -> PlatformCollectionViewLayoutAttributes? {
        let layoutAttribute = super.layoutAttributesForItem(at: indexPath)
        self.totalItemHeight += layoutAttribute?.frame.size.height ?? 0
        return layoutAttribute
    }
}
