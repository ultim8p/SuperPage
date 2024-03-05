//
//  CompBorderModifier.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/21/24.
//

import SwiftUI

enum CompBackgroundStyle {
    
    case barButton
}

struct CompBackgroundModifier: ViewModifier {
    
    var color: AppColor
    var shape: CompShapeStyle
    
    func body(content: Content) -> some View {
            content
                .background(backgroundView())
                .clipShape(clipShape())
        }

        @ViewBuilder private func backgroundView() -> some View {
            switch shape {
            case .rounded:
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(color.color)
            case .roundedRectangle(let radius):
                RoundedRectangle(cornerRadius: radius.value)
                    .fill(color.color)
            case .rectangle:
                    Rectangle()
                    .fill(color.color)
            case .none:
                Rectangle()
                    .fill(Color.clear)
            }
        }

        private func clipShape() -> some Shape {
            switch shape {
            case .rounded:
                return AnyShape(RoundedRectangle(cornerRadius: .infinity))
            case .roundedRectangle(let radius):
                return AnyShape(RoundedRectangle(cornerRadius: radius.value))
            case .rectangle:
                return AnyShape(RoundedRectangle(cornerRadius: 0.0))
            case .none:
                return AnyShape(Rectangle())
            }
        }
}

extension View {
    
    func compBackground(color: AppColor, shape: CompShapeStyle) -> some View {
        self.modifier(CompBackgroundModifier(color: color, shape: shape))
    }
}
