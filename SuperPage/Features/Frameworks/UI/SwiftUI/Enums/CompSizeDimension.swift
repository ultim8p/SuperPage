//
//  CompSizeDimension.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/22/24.
//

import SwiftUI

enum CompSizeDimension {
    
    case small
    
    case medium
    
    case regular
    
    var value: CGFloat {
        switch self {
        case .small:
#if os(macOS)
        return 30.0
#else
        return 35
#endif
        case .medium:
#if os(macOS)
        return 42.0
#else
        return 48.0
#endif
        case .regular:
#if os(macOS)
            return 48.0
#else
        return 55.0
#endif
        }
    }
}
