//
//  EmptyCreateChatView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/24/24.
//

import SwiftUI

struct EmptyCreateChatView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        ZStack {
            AppColor.main.color
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack(alignment: .center) {
                Spacer()
                CompButton {
                    openCreate()
                } label: {
                    VStack {
                        HStack {
                            Spacer()
                            CompIcon(size: .xLarge, iconSize: .xLarge, icon: .folderBadgePlus, color: .highlight)
                            Spacer()
                        }
                        Text("Create your first folder.")
                            .compText(fontStyle: .body)
                    }
                }
                Spacer()
#if os(iOS)
                CompButton {
                    openCreate()
                } label: {
                    Text("Create Folder")
                        .compText(fontStyle: .title3, fontWeight: .bold)
                        .componentMainButton()
                }
                .padding()
#endif
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func openCreate() {
        navigationManager.creatingChat = Chat()
    }
}

#Preview {
    EmptyCreateChatView()
//        .environmentObject(NavigationManager.mock)
}
