//
//  SuperColor.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/13/23.
//

import Foundation
import SwiftUI

extension Color {
    static var branchBackground: Color {
        return Color("branchBackground")
    }
    
    static var homeBackground: Color {
        return Color("homeBackground")
    }
    
    static var alert: Color {
        return Color("alert")
    }
    
    static var icon: Color {
        return Color("icon")
    }
}

class SuperColor {
    
    static var lineSeparator: NOColor {
        return NOColor(named: "lineSeparator")!
    }
    
    // TOOLBAR
    
    static var toolBar: NOColor {
        return NOColor(named: "toolBarColor")!
    }
    
    static var icon: NOColor {
        return NOColor(named: "icon")!
    }
    
    // TEXT
    
    static var defaultText: NOColor {
        return NOColor(named: "codeDefaultText")!
    }
    
    static var textPlaceholder: NOColor {
        return NOColor(named: "textPlaceholder")!
    }
    
    // BACKGROUND
    
    static var popupBackground: NOColor {
        return NOColor(named: "popupBackground")!
    }
    
    static var userMessageBackground: NOColor {
        return NOColor(named: "userMessageBackground")!
    }
    
    static var homeBackground: NOColor {
        return NOColor(named: "homeBackground")!
    }
    
    static var branchBackground: NOColor {
        return NOColor(named: "branchBackground")!
    }
    
    // CODE
    static var codeDefaultText: NOColor {
        return NOColor(named: "codeDefaultText")!
    }
    
    static var codeBlock: NOColor {
        return NOColor(named: "codeBlock")!
    }
    
    // INDICATORS
    
    static var indicatorUser: NOColor {
        return NOColor(named: "indicatorUser")!
    }
    
    static var indicatorAIModel: NOColor {
        return NOColor(named: "indicatorAIModel")!
    }
    
    static var alert: NOColor {
        return NOColor(named: "alert")!
    }
}
