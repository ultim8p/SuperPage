//
//  ChatsScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import SwiftUI

struct ChatsScreen: View {
    
    var body: some View {
        NavView {
            ZStack {
                Color.orange.ignoresSafeArea()
                NavLink(destination:
                            Text("Destination")
                    .navTitle("Second Screen")
                    .navLeftButton(.chevronLeft)
                ) {
                    Text("Navigate")
                }
            }
            .navBarItems(title: "Home", subtitle: "Welcome Back")
        }
    }
}
