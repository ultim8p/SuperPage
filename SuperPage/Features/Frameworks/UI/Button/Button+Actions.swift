//
//  Button+Actions.swift
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

extension PlatformButton {
    
    #if os(macOS)
    func noTarget(_ target: AnyObject?, action: Selector) {
        self.target = target
        self.action = action
    }
    #elseif os(iOS)
    func noTarget(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    #endif
}
