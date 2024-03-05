//
//  BranchToolBar.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/25/24.
//

import SwiftUI

struct BranchToolBar: View {

    @EnvironmentObject var branchEditState: BranchEditState
    
    var body: some View {
        ZStack {
            AppColor.mainSecondary.color
                .frame(height: 50.0)
            HStack(spacing: 0) {
                let sendDisabled = branchEditState.newMessage.isEmpty
                VStack {
                    Spacer()
//                    if branchEditState.messagesCount > 0 {
                        CompButton {
                            messagesButtonAction()
                        } label: {
                            HStack(spacing: 0) {
                                CompIcon(size: .large, iconSize: .small, icon: branchEditState.selectedMessages.count > 0 ? .checkmarkSquare : .square, color: .highlight, weight: .regular)
                                Text("\(branchEditState.selectedMessages.count) messages")
                                    .foregroundStyle(AppColor.highlight.color)
                                    .font(.system(size: 18))
                                    .padding(.leading, -6)
                            }
                        }
                        .frame(height: 50.0)
//                    }
                    Spacer()
                }
                .padding(.leading)
                Spacer()
                
                CompButton {
                    modelButtonAction()
                } label: {
                    HStack(spacing: 0) {
                        Text("🤖")
                            .font(.system(size: 18))
                        Text(branchEditState.model.displayName ?? "")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppColor.highlight.color)
                            .padding(.leading, 4)
                    }
                }
                .frame(height: 50.0)
                
                CompButton {
                    sendMessageButtonAction()
                } label: {
                    CompIcon(size: .large, iconSize: .custom(24), icon: .paperplaneFill, color: .highlight)
                        .opacity(sendDisabled ? 0.5 : 1.0)
                }
                .disabled(sendDisabled)
                .frame(height: 50.0)
                .padding(.leading, 10).padding(.trailing, 10)

            }
        }
        .frame(height: 50.0)
    }
}

private extension BranchToolBar {
    
    func sendMessageButtonAction() {
        branchEditState.sendMessage()
    }
    
    func messagesButtonAction() {
        branchEditState.didTapSelectedMessages()
    }
    
    func modelButtonAction() {
        branchEditState.modelButtonAction()
    }
}

#Preview {
    BranchToolBar()
        .environmentObject(BranchEditState.mock)
}
