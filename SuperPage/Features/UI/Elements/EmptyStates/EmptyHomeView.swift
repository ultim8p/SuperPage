//
//  EmptyHomeView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/25/24.
//

import SwiftUI

struct EmptyHomeView: View {
    
    var body: some View {
        ZStack {
            AppColor.main.color
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                Spacer()
                
                Text("Welcome to\nSuperPage")
                    .compText(fontStyle: .largeTitle, fontWeight: .black)
                    .padding(.bottom, 50)
                
                Text("Try some shortcuts:")
                    .compText(fontStyle: .body, fontWeight: .regular)
                    .padding(.bottom, 2)
                
                Text("⌘ P")
                    .foregroundColor(AppColor.contrast.color)
                    .font(.system(.title, weight: .black)) +
                Text(" to create a new Page.")
                    .foregroundColor(AppColor.contrastSecondary.color)
                    .font(.system(.body))
                
                Text("⌘ K")
                    .foregroundColor(AppColor.contrast.color)
                    .font(.system(.title, weight: .black)) +
                Text(" to navigate to Pages.")
                    .foregroundColor(AppColor.contrastSecondary.color)
                    .font(.system(.body))
                
                Text("⌘ E")
                    .foregroundColor(AppColor.contrast.color)
                    .font(.system(.title, weight: .black)) +
                Text(" inside a Page to edit.")
                    .foregroundColor(AppColor.contrastSecondary.color)
                    .font(.system(.body))
                
                Spacer()
            }
            .padding(.leading, 80).padding(.trailing, 80)
        }
    }
}

#Preview {
    EmptyHomeView()
}
