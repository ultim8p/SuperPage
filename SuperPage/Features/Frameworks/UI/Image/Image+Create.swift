//
//  Image+Create.swift
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

extension PlatformImage {
    
    static func noSymbol(name: String) -> PlatformImage {
    #if os(macOS)
        return PlatformImage(systemSymbolName: name, accessibilityDescription: "")!
    #elseif os(iOS)
        return UIImage(systemName: name)!
    #endif
    }
}
