//
//  AppIcon.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/21/24.
//

import SwiftUI

enum IconSize {
    
    case xSmall
    
    case small
    
    case medium
    
    case large
    
    case xLarge
    
    case custom(_ custom: CGFloat)
    
    var size: CGSize {
        switch self {
        case .xSmall:
            return CGSize(width: 16.0, height: 16.0)
        case .small:
            return CGSize(width: 24.0, height: 24.0)
        case .medium:
            return CGSize(width: 32.0, height: 32.0)
        case .large:
            return CGSize(width: 46.0, height: 46.0)
        case .xLarge:
            return CGSize(width: 64.0, height: 64.0)
        case .custom(let custom):
            return CGSize(width: custom, height: custom)
        }
    }
}

struct CompIcon: View {
    
    let size: IconSize
    let iconSize: IconSize
    let icon: AppIcon
    let color: AppColor
    let weight: Font.Weight

    init(size: IconSize, iconSize: IconSize, icon: AppIcon, color: AppColor, weight: Font.Weight = .regular) {
        self.size = size
        self.iconSize = iconSize
        self.icon = icon
        self.weight = weight
        self.color = color
    }
    
    var body: some View {
        ZStack {
            icon.image
                .resizable()
                .scaledToFit()
                .font(.system(size: iconSize.size.width, weight: weight))
                .foregroundColor(color.color)
                .frame(width: iconSize.size.width, height: iconSize.size.height)
        }
        .frame(width: size.size.width, height: size.size.height)
    }
}

#Preview {
    VStack {
        CompIcon(size: .medium,  iconSize: .xSmall, icon: .arrowTurnDownRight, color: .contrast, weight: .bold)
        .compBackground(color: .alert, shape: .rounded)
        .compBorder(color: .primary, width: .bold, shape: .rounded)
        .padding()
        
        CompIcon(size: .medium, iconSize: .xSmall, icon: .arrowTurnDownRight, color: .contrast)
        
        CompIcon(size: .medium, iconSize: .xSmall, icon: .arrowTurnDownRight, color: .contrast, weight: .black)
        .compBorder(color: .primary, width: .regular, shape: .rounded)
        CompIcon(size: .small, iconSize: .xSmall, icon: .doc, color: .primary)
            .compBorder(color: .highlight, width: .thin, shape: .roundedRectangle(.pill))
    }
}
