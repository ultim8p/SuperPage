//
//  ComponentMainButton.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/25/24.
//

import SwiftUI

struct ComponentMainButton: ViewModifier {
    
    let color: AppColor
    
    let dimension: CompSizeDimension
    
    func body(content: Content) -> some View {
        content
            .compFrame(style: .rectangle(height: dimension))
            .compBackground(color: color, shape: .roundedRectangle(.soft))
    }
}

extension View {
    
    func componentMainButton(color: AppColor = .primary) -> some View {
        var dimension: CompSizeDimension = .regular
        #if os(macOS)
        dimension = .medium
        #endif
        return modifier(ComponentMainButton(color: color, dimension: dimension))
    }
    
    func componentMainButtonSmall(color: AppColor = .primary) -> some View {
        modifier(ComponentMainButton(color: color, dimension: .small))
    }
}
