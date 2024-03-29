//
//  CompSizeDimension.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/22/24.
//

import SwiftUI

enum CompSizeDimension {
    
    case small
    
    case regular
    
    var value: CGFloat {
        switch self {
        case .small:
            return 40.0
        case .regular:
            return 55.0
        }
    }
}
