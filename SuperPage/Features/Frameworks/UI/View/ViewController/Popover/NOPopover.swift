//
//  NOPopover.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/14/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

protocol NOPopoverable {
    
    var popover: NOPopoverViewController? { get set }
    
    mutating func show(in viewController: PlatformViewControler, fromRect: PlatformRect, relativeTo: PlatformRect, size: PlatformSize)
}

extension NOPopoverable where Self: PlatformViewControler {
    
    mutating func show(in viewController: PlatformViewControler, fromRect: PlatformRect, relativeTo: PlatformRect, size: PlatformSize) {
        popover = NOPopoverViewController(contentViewController: self)
        popover?.show(in: viewController, fromRect: fromRect, relativeTo: relativeTo, size: size)
    }
}
