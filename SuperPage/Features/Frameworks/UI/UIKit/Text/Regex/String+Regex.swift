//
//  String+Regex.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/12/23.
//

import Foundation

extension String {
    
    func regularExpression(options: NSRegularExpression.Options = []) -> NSRegularExpression? {
        return try? NSRegularExpression(pattern: self, options: options)
    }
    
    func markupRanges(regex: String, options: NSRegularExpression.Options = [.dotMatchesLineSeparators]) -> [NSRange] {
        var ranges: [NSRange] = []
        let regexOptions: NSRegularExpression.Options = options
        do {
            let regex = try NSRegularExpression(pattern: regex, options: regexOptions)
            let nsString = self as NSString
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
            
            for match in matches {
                let contentRange = match.range(at: 1)
                ranges.append(contentRange)
            }
        } catch {
            print("Invalid regex pattern")
        }
        return ranges
    }
    
    func ranges(regex: String, markupRange: NSRange, options: NSRegularExpression.Options = []) -> [NSRange] {
        guard let regex = regex.regularExpression(options: options) else { return [] }
        var ranges: [NSRange] = []
        regex.enumerateMatches(in: self, options: [], range: markupRange) { result, _, _ in
            guard let resultRange = result?.range else { return }
            ranges.append(resultRange)
        }
        return ranges
    }
}
