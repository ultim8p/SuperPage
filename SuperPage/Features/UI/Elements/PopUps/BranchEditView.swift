//
//  BranchEditView.swift
//  SuperPage
//
//  Created by Guerson Perez on 9/26/23.
//

import SwiftUI

struct BranchEditView: View {
    
    @EnvironmentObject var chatInteractor: ChatInteractor
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEmojiPicker = false
    
    @Binding private var name: String
    @Binding private var role: String
    @Binding private var emoji: String?
    @State private var placeholder: String = "Give a personality to the Page by describe how you woult like it to respond, it can be as complex as specific as you wish.\nExamples:\n  - Act as a senior software developer.\n  - Respond by translating every message into French.\n  - Make all responses no longer than a paragraph."
    
    typealias EditedHandler = ((_ name: String?, _ role: String?, _ emoji: String?) -> Void)
    var editedHandler: EditedHandler?
    
    init(name: Binding<String>, role: Binding<String>, emoji: Binding<String?>, editedHandler: EditedHandler? = nil) {
        _name = name
        _role = role
        _emoji = emoji
        self.editedHandler = editedHandler
    }
    
    var body: some View {
        ZStack {
            Color.homeBackground
                .ignoresSafeArea(.all)
            
            VStack {
                VStack {
                    Text("Name")
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
                        
                        SuperTextField(text: $name)
                        
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .padding(.bottom)
                
                VStack {
                    Text("Personality")
                    SuperTextEditor(text: $role, placeholder: $placeholder)
                }
                .padding(.leading)
                .padding(.trailing)
                
                
                HStack {
                    BarButton(backgroundColor: .alert, titleColor: .spDefaultText, title: "Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    BarButton(backgroundColor: .spAction, titleColor: .spDefaultText, title: "Save") {
                        didSave()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
            }
            .frame(minWidth: 350, minHeight: 350)
            .padding()
        }
    }
    
    func didSave() {
        let savedName = name.isEmpty ? nil : name
        let savedRole = role.isEmpty ? nil : role
        editedHandler?(savedName, savedRole, emoji)
    }
}

//struct ElementSheetView_Previews: PreviewProvider {
                            
//    static var previews: some View {
//        BranchEditView(name: "My branch", role: "Description", emoji: "@")
//            .environmentObject(ChatInteractor.mock)
//    }
//}
