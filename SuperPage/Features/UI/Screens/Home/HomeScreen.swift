//
//  HomeScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation
import SwiftUI

struct HomeScreen: View {
    
    // MARK: Navigation State
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    // MARK: App State
    
    @EnvironmentObject var settingsState: SettingsState
    
    @EnvironmentObject var chatsState: ChatsState
    
    // MARK: View State
    
    @State var branchName: String = ""
    
    @State private var showChatCreation = false
    @State private var showBranchCreation = false
    
    @State private var showTest = false
    
    @State private var chatContextMenu: Chat = Chat()
    
    @State var path = NavigationPath()
    
    // Selected Chat
    
    @State var systemRole: String = ""
    
    var body: some View {
        ZStack {
            AppColor.mainSecondary.color
                .ignoresSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            HomeShortcutsView()
            NavigationSplitView {
                ZStack {
                    AppColor.mainSecondary.color
                        .ignoresSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack(spacing: 0) {
                        ChatsListView(
                            branchName: $branchName,
                            showBranchCreation: $showBranchCreation,
                            chatContextMenu: $chatContextMenu,
                            selectedChat: .constant(nil)
                        )

//                        if settingsState.settingsUsage.shouldShowTokensLeft {
//                            CompSeparator()
//                            HomeTokenStatsView()
//                        }
//                        
//                        HomeUpgradeView()
                        CompSeparator()
                            .zIndex(1)
                        HomeToolBar(showChatCreation: $showChatCreation)
                    }
                }
            } detail: {
                BranchScreenDetail()
            }
            .tint(AppColor.highlight.color)
            .background(Color.clear)
#if os(macOS)
            .toolbarBackground(Color.branchBackground, for: .windowToolbar)
#endif
        }
        .rootSheetsModifier()
    }
}

extension HomeScreen {
    
    func sendMessage(message: String, model: AIModel, branch: Branch, messageIds: [String]) {
        guard !message.isEmpty else { return }
        chatsState.postCreateMessage(
            text: message,
            model: model,
            branch: branch,
            messageIds: messageIds
        )
    }
}

struct HomeScreen_Previews: PreviewProvider {
                            
    static var previews: some View {
        HomeScreen()
            .environmentObject(SettingsState.mock)
            .environmentObject(ChatsState.mock)
    }
}
