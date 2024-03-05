//
//  BackgroundBorder.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/21/24.
//

import SwiftUI

struct CompBorder: ViewModifier {
    
    var color: AppColor
    var width: CompBorderWidthStyle
    var shape: CompShapeStyle

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Group {
                        switch shape {
                        case .rounded:
                            RoundedRectangle(cornerRadius: min(geometry.size.width, geometry.size.height) * 0.5)
                                .stroke(color.color, lineWidth: width.value)
                        case .roundedRectangle(let radius):
                            RoundedRectangle(cornerRadius: radius.value)
                                .stroke(color.color, lineWidth: width.value)
                        case .rectangle:
                            Rectangle()
                                .stroke(color.color, lineWidth: width.value)
                        case .none:
                            Rectangle()
                        }
                    }
                }
            )
    }
}

extension View {
    func compBorder(color: AppColor, width: CompBorderWidthStyle, shape: CompShapeStyle) -> some View {
        modifier(CompBorder(color: color, width: width, shape: shape))
    }
}
