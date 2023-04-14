//
//  SuperColor.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/13/23.
//

import Foundation

class SuperColor {
    
    
    static var lineSeparator: PlatformColor {
        return PlatformColor(named: "lineSeparator")!
    }
    
    // TOOLBAR
    
    static var toolBar: PlatformColor {
        return PlatformColor(named: "toolBarColor")!
    }
    
    static var icon: PlatformColor {
        return PlatformColor(named: "icon")!
    }
    
    // TEXT
    
    static var defaultText: PlatformColor {
        return PlatformColor(named: "codeDefaultText")!
    }
    
    static var textPlaceholder: PlatformColor {
        return PlatformColor(named: "textPlaceholder")!
    }
    
    // BACKGROUND
    
    static var popupBackground: PlatformColor {
        return PlatformColor(named: "popupBackground")!
    }
    
    static var userMessageBackground: PlatformColor {
        return PlatformColor(named: "userMessageBackground")!
    }
    
    // CODE
    static var codeDefaultText: PlatformColor {
        return PlatformColor(named: "codeDefaultText")!
    }
    
    static var codeBlock: PlatformColor {
        return PlatformColor(named: "codeBlock")!
    }
    
    static var branchBackground: PlatformColor {
        return PlatformColor(named: "branchBackground")!
    }
}
