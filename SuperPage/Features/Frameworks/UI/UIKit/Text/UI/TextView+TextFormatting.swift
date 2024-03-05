//
//  TextView+TextFormatting.swift
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

extension TextFormatting where Self: NOTextView {
    
    func refreshFormat() {
        markupRanges = [:]
        formatters.forEach { formatter in
            add(formatter: formatter)
        }
    }
    
    func addFormatting(attributes: [NSAttributedString.Key: Any], regex: NSRegularExpression?, range: NSRange?) {
    #if os(macOS)
        guard let textStorage else { return }
    #endif
        let range = range ?? NSRange(location: 0, length: noText.utf16.count)
        guard let regex else {
            textStorage.addAttributes(attributes, range: range)
            return
        }
        regex.enumerateMatches(in: noText, options: [], range: range) { result, _, _ in
            guard let result = result else { return }
            textStorage.addAttributes(attributes, range: result.range)
        }
    }

    func add(formatter: TextFormatter) {
        guard let attributes = formatter.attribtues else { return }
        
        guard let markupRegex = formatter.markupRegex else {
            guard let regexPattern = formatter.regexPattern else {
                addFormatting(attributes: attributes, regex: nil, range: nil)
                return
            }
            
            let formatRanges = noText.ranges(
                regex: regexPattern,
                markupRange: NSRange(noText.startIndex..<noText.endIndex, in: noText),
                options: [.anchorsMatchLines]
            )
            formatRanges.forEach { formatRange in
                addFormatting(
                    attributes: attributes,
                    regex: regexPattern.regularExpression(),
                    range: formatRange)
            }
            return
        }
        
        let markupRanges = ensureMarkupRanges(markupRegex: markupRegex)
        
        guard let regexPattern = formatter.regexPattern else {
            markupRanges.forEach { markupRange in
                addFormatting(attributes: attributes, regex: nil, range: markupRange)
            }
            return
        }
        
        markupRanges.forEach { markupRange in
            let formatRanges = noText.ranges(regex: regexPattern, markupRange: markupRange)
            formatRanges.forEach { formatRange in
                addFormatting(
                    attributes: attributes,
                    regex: regexPattern.regularExpression(),
                    range: formatRange)
            }
        }
    }
    
    private func ensureMarkupRanges(markupRegex: String) -> [NSRange] {
        guard markupRanges.contains(where: { $0.key == markupRegex }),
              let ranges = markupRanges[markupRegex] else {
            let ranges = noText.markupRanges(regex: markupRegex)
            markupRanges[markupRegex] = ranges
            return ranges
        }
        return ranges
    }
}
