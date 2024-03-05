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
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @Binding var showChatCreation: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            CompButton {
                navigationManager.creatingChat = Chat()
            } label: {
                CompIcon(size: .medium, iconSize: .custom(38), icon: .folderBadgePlus, color: .highlight, weight: .regular)
            }
            Spacer()
            CompButton {
                var chat: Chat? = nil
                if let chatId = navigationManager.selectedChatId,
                   let selectedChat = chatInt.chat(for: chatId)?.chat {
                    chat = selectedChat
                } else if let firstChat = chatInt.chats.first {
                    chat = firstChat
                }
                guard let chat else { return }
                
                navigationManager.fromChatCreatingBranch = chat
            } label: {
                CompIcon(size: .small, iconSize: .custom(32), icon: .docBadgePlus, color: .highlight, weight: .regular)
            }
            Spacer()
            CompButton {
                
            } label: {
                CompIcon(size: .small, iconSize: .custom(30), icon: .textMagnifyingGlass, color: .highlight, weight: .light)
            }
            Spacer()
            CompButton {
                navigationManager.openSettings()
            } label: {
                CompIcon(size: .small, iconSize: .custom(30), icon: .gearShape, color: .highlight, weight: .regular)
            }
            Spacer()
        }
        .frame(height: 50.0)
        .compBackground(color: .mainSecondary, shape: .rectangle)
    }
}

struct HomeToolBar_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeToolBar(showChatCreation: .constant(false))
            .environmentObject(NavigationManager.mock)
            .environmentObject(ChatInteractor.mock)
    }
}
