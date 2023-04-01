//
//  BranchDetailScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if os(iOS)
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct BranchDetailScreen: View {
    
    @State private var independentMessages: Bool = true
    
    @State private var text = ""
    @State private var systemMessage = ""
    
    @FocusState private var textEditing: Bool
    
    var branch: Branch
    
    @EnvironmentObject var chatInt: ChatInteractor

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Toggle("Reply as independent messages", isOn: $independentMessages)
                }
                TextField("Order(ex): Only reply with poems.", text: $systemMessage, axis: .vertical)
            }
            .padding([.leading, .trailing])
            List {
                ForEach(chatInt.messages) { message in
                    let role = message.role
                    let isAssistant = role == .assistant
                    let separator: Visibility = isAssistant ? .visible : .hidden
                    VStack(alignment: .leading, spacing: 0) {
                        Text(role?.rawValue ?? "")
                            .font(.headline)
                        Text(message.text ?? "")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .disabled(false)
                            .textSelection(.enabled)
                            
                    }
                    .addReadablePadding()
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init())
                    .listRowSeparator(separator)
                    .onTapGesture {
                        #if os(iOS)
                        UIApplication.shared.endEditing()
                        #endif
                    }
                }
                
                HStack {
                    TextField("Type...", text: $text, axis: .vertical)
                        .onSubmit {
                            #if os(macOS)
                            let modifiers = NSApplication.shared.currentEvent?.modifierFlags ?? []
                            if modifiers.contains(.shift) {
                                chatInt.postCreateMessage(
                                    text: text,
                                    branch: branch,
                                    independentMessages: independentMessages,
                                    systemMessage: systemMessage)
                                text = ""
                            } else {
                                text.append("\n")
                                textEditing = true
                            }
                            #endif
                        }
                        .padding([.top, .bottom])
                        .focused($textEditing)
                        .addReadablePadding()
                    #if os(iOS)
                    Button {
                        guard !text.isEmpty else { return }
                        chatInt.postCreateMessage(
                            text: text,
                            branch: branch,
                            independentMessages: independentMessages,
                            systemMessage: systemMessage)
                        text = ""
                    } label: {
                        Image(systemName: SystemImage.paperplaneFill.rawValue)
                            .font(.title2)
                    }
                    #endif
                    
                }
                .listRowBackground(Color.clear)
                .ignoresSafeArea(edges: [.top, .bottom])
                .listRowInsets(.init())
        }
        

        }
        .onAppear{
            chatInt.messages = []
            chatInt.getMessages(branch: branch)
        }
    }
}

extension View {
    
    func addReadablePadding() -> some View {
    #if os(macOS)
        return self.padding([.leading, .trailing], 80)
    #elseif os(iOS)
        return self
    #endif
    }
}

struct BranchDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        BranchDetailScreen(branch: Branch())
            .environmentObject(ChatInteractor.mock)
    }
}
