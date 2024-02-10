//
//  BarButton.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/9/24.
//

import SwiftUI

struct BarButtonLabel: View {
    
    var backgroundColor: Color
    
    var titleColor: Color
    
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(titleColor)
            .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
            .background(backgroundColor)
            .cornerRadius(10)
    }
}

struct BarButton: View {
    
    var backgroundColor: Color
    
    var titleColor: Color
    
    var title: String
    
    var action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            BarButtonLabel(
                backgroundColor: backgroundColor,
                titleColor: titleColor,
                title: title
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BarButton_Previews: PreviewProvider {
    
    static var previews: some View {
        BarButton(backgroundColor: .red, titleColor: .white, title: "Continue to Print", action: {})
    }
}

