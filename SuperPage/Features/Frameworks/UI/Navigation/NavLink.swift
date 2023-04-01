//
//  NavLink.swift
//  Atlet
//
//  Created by Guerson Perez on 2/6/23.
//

import SwiftUI

struct NavLink<Label: View, Destination: View>: View {
    
    let destination: Destination
    let label: Label
    
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        NavigationLink {
            NavBarContentView {
                destination
            }
            #if !os(macOS)
            .navigationBarHidden(true)
            #else
            #endif
        } label: {
            label
        }
    }
}

struct NavLink_Previews: PreviewProvider {
    static var previews: some View {
        NavView {
            NavLink(destination: Text("Destination")) {
                Text("Click Me")
            }
        }
    }
}
