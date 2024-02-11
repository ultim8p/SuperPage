//
//  BranchEditView.swift
//  SuperPage
//
//  Created by Guerson Perez on 9/26/23.
//

import SwiftUI

//final class BranchEditViewModel {
//    
//    @Binding var name: String
//    @Binding var role: String
//    @Binding var emoji: String?
//    @State var placeholder: String = "Give a personality to the Page by describe how you woult like it to respond, it can be as complex as specific as you wish.\nExamples:\n  - Act as a senior software developer.\n  - Respond by translating every message into French.\n  - Make all responses no longer than a paragraph."
//    
//    init(name: String, role: String, emoji: String? = nil, placeholder: String) {
//        self._name = name
//        self._role = role
//        self._emoji = emoji
//        self._placeholder = placeholder
//    }
//}

struct BranchEditView: View {
    
    @EnvironmentObject var chatInteractor: ChatInteractor
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEmojiPicker = false
    
    var isCreating: Bool = false
    
    @State private var name: String
    @State private var role: String
    @State private var emoji: String?
    @State private var placeholder: String = "Give a personality to the Page by describe how you would like it to respond, it can be as complex or specific as you wish.\nExamples:\n  - Act as a senior software developer.\n  - Respond by translating every message into French.\n  - Make all responses no longer than a paragraph."
    
    typealias EditedHandler = ((_ name: String?, _ role: String?, _ emoji: String?) -> Void)
    var editedHandler: EditedHandler?
    
    init(isCreating: Bool, name: String?, role: String?, emoji: String?, editedHandler: EditedHandler? = nil) {
        self.isCreating = isCreating
        self._name = State(initialValue: name ?? "")
        self._role = State(initialValue: role ?? "")
        self._emoji = State(initialValue: emoji)
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
                    SuperTextEditor(text: $role, placeholder: $placeholder) { shortcut in
                        switch shortcut {
                        case .commandEnter:
                            didSave()
                        default:
                            break
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                
                HStack {
                    BarButton(backgroundColor: .alert, titleColor: .spDefaultText, title: "Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    BarButton(backgroundColor: .spAction, titleColor: .spDefaultText, title: isCreating ? "Create" : "Save") {
                        didSave()
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
        presentationMode.wrappedValue.dismiss()
        presentationMode.wrappedValue.dismiss()
    }
}

//struct ElementSheetView_Previews: PreviewProvider {
                            
//    static var previews: some View {
//        BranchEditView(name: "My branch", role: "Description", emoji: "@")
//            .environmentObject(ChatInteractor.mock)
//    }
//}
