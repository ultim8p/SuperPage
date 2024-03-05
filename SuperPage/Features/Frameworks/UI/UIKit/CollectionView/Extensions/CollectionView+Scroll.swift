//
//  CollectionView+Scroll.swift
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
    
    func scrollToBottom(animated: Bool = false) {
    #if os(macOS)
        guard let scrollView = enclosingScrollView else { return }

            let contentHeight = frame.height
            let visibleHeight = scrollView.frame.height
            let bottomInset = scrollView.contentInsets.bottom
            let topInset = scrollView.contentInsets.top
            let adjustedContentHeight = contentHeight + topInset + bottomInset

            let targetY = max(adjustedContentHeight - visibleHeight, 0)

            let bottomPoint = NSPoint(x: 0, y: targetY)
            
            if animated {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.5
                    context.allowsImplicitAnimation = true
                    scrollView.contentView.animator().setBoundsOrigin(bottomPoint)
                    scrollView.reflectScrolledClipView(scrollView.contentView)
                }, completionHandler: nil)
            } else {
                scrollView.contentView.scroll(to: bottomPoint)
                scrollView.reflectScrolledClipView(scrollView.contentView)
            }
        
//            let contentHeight = frame.height
//            let visibleHeight = scrollView.frame.height
//            let bottomInset = scrollView.contentInsets.bottom
//            let topInset = scrollView.contentInsets.top
//            let adjustedContentHeight = contentHeight + topInset + bottomInset
//
//            let targetY = max(adjustedContentHeight - visibleHeight, 0)
//
//            let bottomPoint = NSPoint(x: 0, y: targetY)
//            scrollView.contentView.scroll(to: bottomPoint)
//            scrollView.reflectScrolledClipView(scrollView.contentView)
            
    #elseif os(iOS)
        let bottomOffset = max(0.0, contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(CGPoint(x: 0, y: bottomOffset), animated: false)
    #endif
    }
    
    func isScrolledToBottom() -> Bool {
    #if os(macOS)
        return enclosingScrollView?.verticalScroller?.floatValue == 1.0
    #elseif os(iOS)
        let bottomOffset = CGPoint(
            x: 0,
            y: max(-contentInset.top, contentSize.height - bounds.height + contentInset.bottom)
        )
        let isScrolledToBottom = abs(contentOffset.y - bottomOffset.y) <= 1
        return isScrolledToBottom
    #endif
    }
}
