//
//  Device+Additions.swift
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

class NODevice {
    
    static var isPhone: Bool {
    #if os(macOS)
        return false
    #elseif os(iOS)
        return UIDevice.current.userInterfaceIdiom == .phone
    #endif
    }
    
    static var isPad: Bool {
    #if os(macOS)
        return false
    #elseif os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad
    #endif
    }
    
    static var isPortrait: Bool {
    #if os(macOS)
        return false
    #elseif os(iOS)
        return UIDevice.current.orientation.isPortrait
    #endif
    }
    
    static func readableWidth(for size: CGFloat) -> CGFloat {
        if size > 800.0 {
            return 750.0
        } else if size > 600 {
            return 550
        } else if size < 500 {
            return size - 32.0
        }
        return 400.0
    }
}
