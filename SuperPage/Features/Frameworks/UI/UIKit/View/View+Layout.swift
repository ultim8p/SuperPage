//
//  View+Layout.swift
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

extension PlatformView {
    func reloadLayoutIfNeeded() {
    #if os(macOS)
        layoutSubtreeIfNeeded()
    #elseif os(iOS)
        layoutIfNeeded()
    #endif
    }
}
