//
//  BranchScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/25/24.
//

import SwiftUI

struct BranchScreen: View {
        
    @EnvironmentObject var branchEditState: BranchEditState
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        ZStack {
            AppColor.main.color
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                BranchViewControllerWrapper(
                    selectedBranchId: $navigationManager.selectedBranchId,
                    branchEditState: branchEditState,
                    chatInteractor: chatInt,
                    sendMessageHandler: { message, model, messageIds in
//                        sendMessage(message: message, model: model, branch: branch, messageIds: messageIds)
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                BranchToolBar()
                    .frame(height: 50.0)
            }
#if os(iOS)
            .navigationBarTitle("Detail View", displayMode: .inline)
//                        .edgesIgnoringSafeArea(.top)
            .toolbarBackground(AppColor.main.color, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
//                                            dismiss()
                                navigationManager.selectedBranchId = nil
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .black))
                                    .foregroundColor(AppColor.highlight.color) // Set the color of your back button
                            }
                        }
                    }
#endif
        }
    }
}

