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

#if os(macOS)
typealias UniversalView = NSView
typealias UniversalTextView = NSTextView
#else
typealias UniversalView = UIView
typealias UniversalTextView = UITextView
#endif

struct ScrollPositionKey: PreferenceKey {
    static var defaultValue: CGFloat? { nil }
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

/*
 
 
 let backgroundView: PlatformView = {
     #if os(macOS)
     let box = NSBox()
     box.boxType = .custom
     box.fillColor = PlatformColor(named: "codeBlock") ?? PlatformColor.clear
     box.cornerRadius = 10
     return box
     #elseif os(iOS)
     let view = PlatformView()
     view.backgroundColor = PlatformColor(named: "codeBlock")
     view.layer.cornerRadius = 10
     return view
     #endif
 }()
 
 */

//extension ScrollViewProxy {
//    private var threshold: CGFloat { 20 }
//
//    var isScrolledToBottom: Bool {
//        get { return UserDefaults.standard.bool(forKey: "isScrolledToBottom") }
//        set { UserDefaults.standard.setValue(newValue, forKey: "isScrolledToBottom") }
//    }
//
//    func isListScrolledToBottom(yOffset: CGFloat) -> Bool {
//        let listHeight = CGFloat(messages.count) * 200
//        let scrollViewHeight = UniversalView().frame.height - 200
//        return (yOffset + scrollViewHeight + threshold) >= listHeight
//    }
//}

/*
struct BranchDetailScreen: View {
    
    @State private var independentMessages: Bool = true
    
    @State private var messageHeights: [CGFloat] = []
    
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
            ScrollViewReader { scrollProxy in
                List {
                    var index = 0
                    ForEach(chatInt.messages) { message in
                        let role = message.role
                        let isAssistant = role == .assistant
                        let backgroundColor: PlatformColor? = isAssistant ?
                            .clear :
                        PlatformColor(named: "userMessageBackground")
                        let topOffset: CGFloat = isAssistant ? 0.0 : 15
                        
                        GeometryReader { geometry in
                            let messageText = message.text ?? ""
                            ResizableTextView(text: .constant(messageText),
                                              backColor: backgroundColor,
                                              onCommandReturn: nil)
                            .onAppear {
                                // Store the height of each TextView
                                index += 1
                                if messageHeights.count <= index {
                                    messageHeights.append(geometry.size.height)
                                }
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
                    //                .onChange(of: text) { newValue in
                    //                    print("DID CHANGE TEXT: \(text)")
                    //                }
                    
                    VStack {
                        ResizableTextView(text: $text, backColor: .clear, onCommandReturn: sendMessage, onHeightChange: { _ in
                            print("height changed")
                            // Scroll to the bottom when the height changes
                            withAnimation(.easeInOut) {
                                scrollProxy.scrollTo("ListBottom", anchor: .bottom)
                            }
                        })
                        
#if os(iOS)
                        HStack {
                            Button {
                                sendMessage()
                            } label: {
                                Image(systemName: SystemImage.paperplaneFill.rawValue)
                                    .font(.title2)
                            }
                        }
#endif
                    }
                    .addReadablePadding()
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    
                    /*
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
                     */
                    VStack {
                        Color(.red)
                            .frame(width: 1.0, height: 100)
                    }
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .id("ListBottom")
                }
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
        print("WILL SEND MSG: \(text)")
        return
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

*/
