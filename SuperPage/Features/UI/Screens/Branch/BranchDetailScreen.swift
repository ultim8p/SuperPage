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
                    Spacer()
                }
                TextField("Instruction(ex): Act as a lawyer.", text: $systemMessage, axis: .vertical)
            }
            .padding([.leading, .trailing])
            List {
                ForEach(chatInt.messages) { message in
                    let role = message.role
                    let isAssistant = role == .assistant
                    let backgroundColor = isAssistant ?
                    Color.clear :
                    Color(red: 79, green: 92, blue: 117, opacity: 0.1)
                    let topOffset: CGFloat = isAssistant ? 0.0 : 15
                    let indicatorIcon = isAssistant ?
                    SystemImage.arrowTurnDownRight.rawValue : SystemImage.chevronCompactRight.rawValue
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top) {
                            if !isAssistant {
                                Image(systemName: indicatorIcon)
                                    .foregroundColor(.cyan)
                            }
                            Text(message.text ?? "")
                                .font(.title3).fontWeight(.light)
                                .foregroundColor(.primary)
                                .textSelection(.enabled)
                                .background(backgroundColor)
                        }
                    }
                    .addReadablePadding()
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .padding(.top, topOffset)
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
                                sendMessage()
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
                        sendMessage()
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
            .background(ignoresSafeAreaEdges: .all)
            .background(Color.white)

        }
        .onAppear {
            chatInt.messages = []
            chatInt.getMessages(branch: branch)
            
            loadSettings()
        }
        .onDisappear {
            saveSettings()
        }
    }
    
    
    func loadSettings() {
        let settings = chatInt.branchSettings(id: branch.id)
        if let isOn = settings["isOn"] as? Bool {
            independentMessages = isOn
        }
        if let sysRole = settings["sysRole"] as? String {
            systemMessage = sysRole
        }
    }
    
    func saveSettings() {
        let settings: [String: Any] = [
            "isOn": independentMessages,
            "sysRole": systemMessage]
        chatInt.saveBranchSettings(id: branch.id, settings: settings)
    }
    
    func sendMessage() {
        saveSettings()
        guard !text.isEmpty else { return }
        chatInt.postCreateMessage(
            text: text,
            branch: branch,
            independentMessages: independentMessages,
            systemMessage: systemMessage)
        text = ""
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
