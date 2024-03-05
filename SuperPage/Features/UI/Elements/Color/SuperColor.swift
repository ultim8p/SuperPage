//
//  SuperColor.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/13/23.
//

import Foundation
import SwiftUI

enum AppColor: String {
    
    // Main
    
    case main = "branchBackground"
    
    case mainSecondary = "homeBackground"
    
    // Primary
    
    case primary = "action"
    
    // Secondary
    
    case secondary = "actionSecondary"
    
    // Alert
    
    case alert = "alert"
    
    // Contrast
    
    case contrast = "codeDefaultText"
    
    case contrastSecondary = "lineSeparator"
    
    // Highlight
    
    case highlight = "icon"
    
    case clear
    
    var color: Color {
        if self == .clear { return Color.clear }
        return Color(rawValue)
    }
}

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
    
    static var lineSeparator: Color {
        return Color("lineSeparator")
    }
    
    static var spDefaultText: Color {
        return Color("codeDefaultText")
    }
    
    static var spPlaceholder: Color {
        return Color("textPlaceholder")
    }
    
    static var spMarkdownCode: Color {
        return Color("markdownCode")
    }
    
    // Highlights
    
    static var spAction: Color {
        return Color("action")
    }
    
    static var spActionSecondary: Color {
        return Color("actionSecondary")
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
    
    static var markdownCode: NOColor {
        return NOColor(named: "markdownCode")!
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
    
    static var action: NOColor {
        return NOColor(named: "action")!
    }
}
