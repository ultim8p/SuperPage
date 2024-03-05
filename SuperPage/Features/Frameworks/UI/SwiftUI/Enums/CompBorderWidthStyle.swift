//
//  CompBorderWidthStyle.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/21/24.
//

import SwiftUI

enum CompBorderWidthStyle {
    case thin
    case regular
    case bold
    case thick

    var value: CGFloat {
        switch self {
        case .thin:
            return 1
        case .regular:
            return 2
        case .bold:
            return 4
        case .thick:
            return 8
        }
    }
}

