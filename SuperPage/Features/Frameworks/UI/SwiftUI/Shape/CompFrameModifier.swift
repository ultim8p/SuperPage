//
//  CompFrameModifier.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/22/24.
//

import SwiftUI

enum CompFrameStyle {
    
    case rectangle(height: CompSizeDimension)
}

private struct CompFrameModifier: ViewModifier {
    
    let style: CompFrameStyle
    
    func body(content: Content) -> some View {
        switch style {
        case .rectangle(let height):
            content
                .frame(maxWidth: .infinity, minHeight: height.value, maxHeight: height.value)
        }
    }
}

extension View {
    
    func compFrame(style: CompFrameStyle) -> some View {
        modifier(CompFrameModifier(style: style))
    }
}
