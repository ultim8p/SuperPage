//
//  TextView+Formatting.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/12/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

protocol TextFormatting: AnyObject {
    
    var markupRanges: [String: [NSRange]] { get set }
    
    // Order matters, last formats will override first formats.
    var formatters: [TextFormatter] { get set }
    
    func refreshFormat()
    
    func addFormatting(attributes: [NSAttributedString.Key: Any], regex: NSRegularExpression?, range: NSRange?)
    
    func add(formatter: TextFormatter)
}
