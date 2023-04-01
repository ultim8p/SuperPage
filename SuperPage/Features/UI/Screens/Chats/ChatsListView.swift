//
//  ChatsScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation
import SwiftUI

struct FileRow: View {
    let name: String
    let folder: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            let leadingSpace: CGFloat = folder ? 0.0 : 24
            HStack {
                let imageName: String = folder ?  SystemImage.folder.rawValue : SystemImage.docPlaintext.rawValue
                let font: Font = folder ? .title3 : .body
                let darkMode = colorScheme == .dark
                let color: Color = darkMode ?
                folder ? .white : Color(CGColor(gray: 0.7, alpha: 1)) :
                folder ? .black : Color(red: 0.0, green: 0.0, blue: 0.0)
                if folder {
                    Image(systemName: SystemImage.chevronRight.rawValue)
                }
                Image(systemName: imageName)
                    .foregroundColor(.cyan)
                    .font(font)
                Text(name)
                    .font(font)
                    .foregroundColor(color)
                Spacer()
            }
            .padding(.leading, leadingSpace)
        }
    }
}
struct ChatsListView: View {
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @Binding var branchName: String
    
    @Binding var showBranchCreation: Bool
    @Binding var chatContextMenu: Chat
    @State var showChatMenu: Bool = false
    
    var body: some View {
        List {
            ForEach(chatInt.chats) { chat in
                Section(
                    header:
                        HStack {
                            FileRow(name: chat.name ?? "No name", folder: true)
                                .onTapGesture {
                                    chatInt.getBranches(chat: chat)
                                }
                            Button {
                                chatContextMenu = chat
                                showChatMenu = true
                            } label: {
                                Image(systemName: SystemImage.listBullet.rawValue)
                            }
                        }
                ) {
                    let branches = chat.branches ?? []
                    ForEach(branches) { branch in
                        NavLink(destination: BranchDetailScreen(branch: branch)
                        ) {
                            HStack {
                                FileRow(name: branch.name ?? "No name", folder: false)
                            }
                        }
                        .contextMenu {
                            Button("Delete Page") {
                                
                            }.tint(Color.red)
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: [.top, .bottom])
            .listRowInsets(.init())
            .listRowBackground(Color.clear)
        }
        .offset(y: 15)
        .confirmationDialog(chatContextMenu.name ?? "", isPresented: $showChatMenu) {
            Button("Create Page") {
                showBranchCreation = true
            }
            Button("Delete Page") {
                
            }
            .tint(Color.red)
        }
    }
}

struct ChatsList_Previews: PreviewProvider {

    @State var branchName: String = ""

    static var previews: some View {
        ChatsListView(
            branchName: .constant(""),
            showBranchCreation: .constant(false),
            chatContextMenu: .constant(Chat()))
        .environmentObject(ChatInteractor.mock)
    }
}
