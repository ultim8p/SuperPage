//
//  ClassNameProtocol.swift
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

protocol ClassNameProtocol {
    
    static var className: String { get }
    
#if os(macOS)
    static var userInterfaceItemIdentifier: NSUserInterfaceItemIdentifier { get }
#endif
}

extension ClassNameProtocol {
    
    static var className: String {
        return String(describing: self)
    }
    
#if os(macOS)
    static var userInterfaceItemIdentifier: NSUserInterfaceItemIdentifier {
        return NSUserInterfaceItemIdentifier("\(className)")
    }
#endif
}
