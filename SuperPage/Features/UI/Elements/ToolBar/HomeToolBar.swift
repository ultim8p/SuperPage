//
//  HomeToolBar.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/31/23.
//

import Foundation
import SwiftUI


struct ButtonIconStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .background(Circle().fill(Color.clear))
    }

}


struct HomeToolBar: View {
    
    @Binding var showChatCreation: Bool
    
    var body: some View {
        HStack {
                Spacer()
                Button {
                    showChatCreation = !showChatCreation
                } label: {
                    Image(systemName: SystemImage.folderBadgePlus.rawValue)
                        .foregroundColor(.blue)
                        
                }
                .buttonStyle(ButtonIconStyle())
                Spacer()
                NavLink(destination: SettingsScreen()) {
                    Image(systemName: SystemImage.gearShape.rawValue)
                        .foregroundColor(.blue)
                        .font(.title)
                }
                .buttonStyle(ButtonIconStyle())
                Spacer()
        }.padding([.bottom, .top])
    }
}

struct HomeToolBar_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeToolBar(showChatCreation: .constant(false))
    }
}
