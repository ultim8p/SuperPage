//
//  BranchCreationView.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/31/23.
//

import Foundation
import SwiftUI

struct BranchCreateView: View {
    
    @EnvironmentObject var chatsState: ChatsState
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEmojiPicker = false
    
    @State private var name: String = ""
    @State private var role: String = ""
    @State private var emoji: String?
    @State private var placeholder: String = "Give a personality to the Page by describe how you would like it to respond, it can be as complex or specific as you wish.\nExamples:\n  - Act as a senior software developer.\n  - Respond by translating every message into French.\n  - Make all responses no longer than a paragraph."
    
    @State var selectedChatId: Chat.ID?
    
    var submitHandler: ((_ name: String, _ role: String?, _ emoji: String?) -> Void)?
    
    @State var initialScrolled = false
    
    var body: some View {
        ZStack {
            Button(action: {
                moveChatDown()
            }, label: {})
            .buttonStyle(.borderless)
            .keyboardShortcut(.downArrow, modifiers: [])
            
            Button(action: {
                moveChatUp()
            }, label: {})
            .buttonStyle(.borderless)
            .keyboardShortcut(.upArrow, modifiers: [])
            
            Button(action: {
                submit()
            }, label: {})
            .buttonStyle(.borderless)
            .keyboardShortcut(.return, modifiers: .command)
            
            Color.homeBackground
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("Create Page")
                            .font(.system(.largeTitle, weight: .black))
                            .foregroundStyle(Color.spDefaultText)
                            .padding(.leading, 0)
                        Spacer()
                    }
                    
                    HStack {
                        Text("Name")
                        .foregroundStyle(Color.spDefaultText)
                        .padding(.bottom, -9)
                        .padding(.top, 10)
                        .padding(.leading, 64)
                        Spacer()
                }
                        
                    HStack {
                        EmojiSelectView(emoji: emoji)
                            .onTapGesture {
                                showingEmojiPicker = true
                            }
                            .popover(
                                isPresented: $showingEmojiPicker,
                                content: {
                                    EmojiPickerView(selectedEmoji: $emoji)
                                })
                        
                        SuperTextField(placeholder: "Page Name", text: $name, editing: true)
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Assistant")
                            .font(.system(.body))
                            .foregroundColor(AppColor.contrast.color) +
                         Text(" (Optional)")
                            .font(.system(.caption))
                            .foregroundColor(AppColor.contrastSecondary.color)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    SuperTextEditor(text: $role, placeholder: $placeholder) { shortcut in
                        switch shortcut {
                        case .commandEnter:
                            break
                        default:
                            break
                        }
                    }
                    .frame(maxHeight: .infinity)
                }
                .padding(.leading)
                .padding(.trailing)
                
                VStack(spacing: 0) {
                    Text("Folder")
                        .foregroundStyle(Color.spDefaultText)
                        .padding(.bottom, 8)
                    ScrollViewReader { value in
                        ScrollView {
                            ForEach(chatsState.chats) { chat in
                                ChatRowShort(
                                    name: chat.name ?? "",
                                    selectedChatId: $selectedChatId,
                                    chat: chat,
                                    selectionHandler: {
                                        selectedChatId = chat.id
                                        
                                    }
                                )
                                .id(chat.id)
                            }
                        }
                        .onChange(of: selectedChatId) { _ in
                            if let selectedChatId = selectedChatId {
                                withAnimation {
                                    value.scrollTo(selectedChatId, anchor: .center)
                                }
                            }
                        }
                        .onAppear {
                            if let selectedChatId, !initialScrolled {
                                value.scrollTo(selectedChatId, anchor: .center)
                                initialScrolled = true
                            }
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                
                HStack {
                    BarButton(backgroundColor: .alert, titleColor: .spDefaultText, title: "Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    BarButton(backgroundColor: .spAction, titleColor: .spDefaultText, title: "Create") {
                        submit()
                    }
                }
                .padding()
            }
            .onAppear {
                guard selectedChatId == nil else { return }
                selectedChatId = chatsState.chats.first?.id
            }
#if os(macOS)
            .frame(minWidth: 400, minHeight: 600)
#else
            .frame(minWidth: 350)
#endif
            .padding()
        }
    }
}

extension BranchCreateView {
    
    func moveChatDown() {
        guard
            let selectedChatId,
            let nextId = chatsState.nextChatId(from: selectedChatId)
        else { return }
        self.selectedChatId = nextId
    }
    
    func moveChatUp() {
        guard 
            let selectedChatId,
            let previousId = chatsState.previousChatId(from: selectedChatId)
        else { return }
        self.selectedChatId = previousId
    }
    
    func submit() {
        guard !name.isEmpty else { return }
        let savedRole = role.isEmpty ? nil : role
        let emoji = (emoji?.isEmpty ?? true) ? nil : emoji
        submitHandler?(name, savedRole, emoji)
        presentationMode.wrappedValue.dismiss()
    }
}

struct BranchCreateView_Previews: PreviewProvider {
                            
    static var previews: some View {
        BranchCreateView()
        .environmentObject(ChatsState.mock)
    }
}
