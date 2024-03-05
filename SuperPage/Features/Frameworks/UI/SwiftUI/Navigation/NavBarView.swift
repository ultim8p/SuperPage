//
//  NavBarView.swift
//  Atlet
//
//  Created by Guerson Perez on 2/6/23.
//

import SwiftUI

struct NavBarView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let leftButton: SystemImage?
    let rightButton: SystemImage?
    let title: String?
    let subtitle: String?
    
    init(leftButton: SystemImage? = nil,
         rightButton: SystemImage? = nil,
         title: String? = nil,
         subtitle: String? = nil) {
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack {
            if let leftButton = leftButton {
                button(leftButton)
            }
            Spacer()
            titleSection
            Spacer()
            if let rightButton = rightButton {
                button(rightButton)
            }
        }
        .padding()
        .accentColor(.white)
        .foregroundColor(.white)
        .font(.headline)
        .background(
            Color.blue
                .ignoresSafeArea(edges: .top)
        )
    }
}

struct NavBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            NavBarView(leftButton: .chevronLeft, rightButton: .heartFill, title: "Custom Navigation Bar", subtitle: "Subtitle")
            Spacer()
        }
    }
}

extension NavBarView {
    
    private func button(_ image: SystemImage) -> some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: image.rawValue)
        }
    }
    
    private var titleSection: some View {
        VStack(spacing: 2) {
            if let title = title {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
            }
            if let subtitle = subtitle {
                Text(subtitle)
            }
        }
    }
}
