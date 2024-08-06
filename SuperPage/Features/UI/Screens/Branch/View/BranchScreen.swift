//
//  BranchScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/25/24.
//

import SwiftUI

struct BranchScreen: View {
        
    // MARK: Navigation State
    
    @EnvironmentObject var branchEditState: BranchEditState
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    // MARK: App State
    
    @EnvironmentObject var chatsState: ChatsState
    
    var body: some View {
        ZStack {
            AppColor.main.color
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                BranchViewControllerWrapper(
                    selectedBranchRef: $navigationManager.selectedBranchRef,
                    branchEditState: branchEditState
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

