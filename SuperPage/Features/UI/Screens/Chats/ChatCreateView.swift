//
//  ChatCreateView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/12/24.
//

import SwiftUI

struct ChatCreateView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    
    var onCreate: ((_ name: String) -> Void)?
    
    var body: some View {
        ZStack {
            Button(action: {
                didSave()
            }, label: {})
            .buttonStyle(.borderless)
            .keyboardShortcut(.return, modifiers: .command)
            
            Color.homeBackground
                .ignoresSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("Create Folder")
                            .font(.system(.largeTitle, weight: .black))
                            .foregroundStyle(Color.spDefaultText)
                            .padding(.leading, 20)
                            .padding(.top, 20)
                        Spacer()
                    }
                    
                    HStack {
                        Text("Name")
                            .font(.system(.headline, weight: .bold))
                        .foregroundStyle(Color.spDefaultText)
                        .padding(.bottom, -9)
                        .padding(.leading, 20)
                        .padding(.top, 10)
                        Spacer()
                    }
                    
                    HStack {
                        SuperTextField(placeholder: "Folder Name", text: $name, editing: true)
                    }
                    
                    HStack {
                        BarButton(backgroundColor: .alert, titleColor: .spDefaultText, title: "Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        BarButton(backgroundColor: .spAction, titleColor: .spDefaultText, title: "Create") {
                            didSave()
                        }
                    }
                    .padding()
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
            }
        }
#if os(macOS)
            .frame(minWidth: 400)
#else
            .frame(minWidth: 350)
#endif
    }
}

extension ChatCreateView {
    
    func didSave() {
        guard !name.isEmpty else { return }
        onCreate?(name)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    ChatCreateView()
}
