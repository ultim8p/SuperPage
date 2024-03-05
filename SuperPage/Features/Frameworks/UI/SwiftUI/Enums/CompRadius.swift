//
//  CompRadius.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/21/24.
//

import Foundation

enum CompRadius {
    
    case sharp
    
    case soft
    
    case pill
    
    case custom(_ radius: CGFloat)
    
    var value: CGFloat {
        switch self {
        case .sharp:
            return 4.0
        case .soft:
            return 8.0
        case .pill:
            return 16.0
        case .custom(let custom):
            return custom
        }
    }
}
