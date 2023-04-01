//
//  NavBarPreferenceKeys.swift
//  Atlet
//
//  Created by Guerson Perez on 2/6/23.
//

import Foundation
import SwiftUI

struct NavBarLeftButtonPreferenceKey: PreferenceKey {
    
    static var defaultValue: SystemImage? = nil
    
    static func reduce(value: inout SystemImage?, nextValue: () -> SystemImage?) {
        value = nextValue()
    }
}

struct NavBarRightButtonPreferenceKey: PreferenceKey {
    
    static var defaultValue: SystemImage? = nil
    
    static func reduce(value: inout SystemImage?, nextValue: () -> SystemImage?) {
        value = nextValue()
    }
}

struct NavBarTitlePreferenceKey: PreferenceKey {
    
    static var defaultValue: String? = nil
    
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
    }
}

struct NavBarSubtitlePreferenceKey: PreferenceKey {
    
    static var defaultValue: String? = nil
    
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
    }
}

extension View {
    
    func navLeftButton(_ leftButton: SystemImage?) -> some View {
        preference(key: NavBarLeftButtonPreferenceKey.self, value: leftButton)
    }
    
    func navRightButton(_ rightButton: SystemImage?) -> some View {
        preference(key: NavBarRightButtonPreferenceKey.self, value: rightButton)
    }
    
    func navTitle(_ title: String?) -> some View {
        preference(key: NavBarTitlePreferenceKey.self, value: title)
    }
    
    func navSubtitle(_ subtitle: String?) -> some View {
        preference(key: NavBarSubtitlePreferenceKey.self, value: subtitle)
    }
    
    func navBarItems(title: String? = nil,
                     subtitle: String? = nil,
                     leftButton: SystemImage? = nil,
                     rightButton: SystemImage? = nil) -> some View {
        self
            .navLeftButton(leftButton)
            .navRightButton(rightButton)
            .navTitle(title)
            .navSubtitle(subtitle)
    }
}
