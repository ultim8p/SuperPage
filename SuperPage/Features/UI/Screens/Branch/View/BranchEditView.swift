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
                VStack(spacing: 0) {
                    HStack {
                        Text("Edit Page")
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
                    BarButton(backgroundColor: .spAction, titleColor: .spDefaultText, title: "Save") {
                        didSave()
                    }
                }
                .padding()
            }
#if os(macOS)
            .frame(minWidth: 400, minHeight: 400)
#else
            .frame(minWidth: 350)
#endif
            .padding()
        }
    }
    
    func didSave() {
        guard !name.isEmpty else { return }
        let savedName = name.isEmpty ? nil : name
        let savedRole = role.isEmpty ? nil : role
        editedHandler?(savedName, savedRole, emoji)
        presentationMode.wrappedValue.dismiss()
    }
}

struct ElementSheetView_Previews: PreviewProvider {
                            
    static var previews: some View {
        BranchEditView(isCreating: false, name: "My branch", role: "Description", emoji: nil)
            .environmentObject(ChatInteractor.mock)
    }
}
