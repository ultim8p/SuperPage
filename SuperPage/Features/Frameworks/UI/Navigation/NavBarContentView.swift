//
//  NavBarContentView.swift
//  Atlet
//
//  Created by Guerson Perez on 2/6/23.
//

import SwiftUI

struct NavBarContentView<Content: View>: View {
    
    let content: Content
    
    @State private var leftButton: SystemImage?
    @State private var rightButton: SystemImage?
    @State private var title: String?
    @State private var subtitle: String?
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavBarView(leftButton: leftButton, rightButton: rightButton, title: title, subtitle: subtitle)
            content.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(NavBarTitlePreferenceKey.self) { value in
            title = value
        }
        .onPreferenceChange(NavBarSubtitlePreferenceKey.self) { value in
            subtitle = value
        }
        .onPreferenceChange(NavBarLeftButtonPreferenceKey.self) { value in
            leftButton = value
        }
        .onPreferenceChange(NavBarRightButtonPreferenceKey.self) { value in
            rightButton = value
        }
    }
}

struct NavBarContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavBarContentView {
            ZStack {
                Color.green.ignoresSafeArea()
                Text("Hello world")
                    .foregroundColor(.white)
            }
            .navBarItems(title: "My world",
                         subtitle: "Sub title",
                         leftButton: .chevronLeft)
        }
    }
}
