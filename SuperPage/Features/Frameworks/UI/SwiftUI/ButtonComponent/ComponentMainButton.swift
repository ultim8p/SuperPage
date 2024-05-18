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
        return modifier(ComponentMainButton(color: color, dimension: .regular))
    }
    
    func componentMainButtonSmall(color: AppColor = .primary) -> some View {
        modifier(ComponentMainButton(color: color, dimension: .small))
    }
}
