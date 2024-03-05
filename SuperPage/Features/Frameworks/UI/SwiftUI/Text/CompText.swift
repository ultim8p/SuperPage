//
//  CompText.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/22/24.
//

import SwiftUI

// Define the ViewModifier
struct CompTextModifier: ViewModifier {
    
    var textColor: AppColor = .contrast
    var numberOfLines: Int? = nil // Default number of lines, nil means no limit
    var fontStyle: Font.TextStyle = .body
    var fontWeight: Font.Weight = .regular

    func body(content: Content) -> some View {
        content
            .foregroundColor(textColor.color)
            .lineLimit(numberOfLines)
            .font(.system(fontStyle, design: .default).weight(fontWeight))
    }
}

// Extension to apply the modifier more easily
extension View {
    func compText(
        textColor: AppColor = .contrast,
        numberOfLines: Int? = nil,
        fontStyle: Font.TextStyle = .body,
        fontWeight: Font.Weight = .regular
    ) -> some View {
        modifier(CompTextModifier(
            textColor: textColor, 
            numberOfLines: numberOfLines,
            fontStyle: fontStyle,
            fontWeight: fontWeight)
        )
    }
}
