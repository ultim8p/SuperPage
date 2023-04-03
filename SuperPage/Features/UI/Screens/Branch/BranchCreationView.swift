//
//  BranchCreationView.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/31/23.
//

import Foundation
import SwiftUI

struct NameEditView: View {
    
    @Binding var presented: Bool
    
    var placeholder: String
    
    var title: String
    
    @State var name: String = ""
    
    var submitHandler: ((_ name: String) -> Void)?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button {
                        presented = false
                    } label: {
                        Image(systemName: SystemImage.xmark.rawValue)
                            .foregroundColor(Color.white)
                    }
                    Text(title)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                FieldNameTextField(text: $name, placeholder: placeholder)
                    .onSubmitName {
                        guard !name.isEmpty else { return }
                        submitHandler?(name)
                        presented = false
                        name = ""
                    }
                Spacer()
            }
            .padding()
            .padding(.top)
            .padding(.top)
        }
    }
}

extension NameEditView {
    
    func onSubmitName(submitHandler: ((_ name: String) -> Void)?) -> some View {
        NameEditView(presented: $presented, placeholder: placeholder, title: title, submitHandler: submitHandler)
    }
}

struct BranchCreationView: View {
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @Binding var presented: Bool
    
    @Binding var name: String
    
    @Binding var chat: Chat
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button {
                        presented = false
                    } label: {
                        Image(systemName: SystemImage.xmark.rawValue)
                            .foregroundColor(Color.white)
                    }
                    Text("Create Page")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                FieldNameTextField(text: $name, placeholder: "Page name...")
                    .onSubmitName {
                        guard !name.isEmpty else { return }
                        chatInt.createBranch(name: name, chat: chat)
                        presented = false
                        name = ""
                    }
                Spacer()
            }
            .padding()
            .padding(.top)
            .padding(.top)
            .onAppear {
                name = ""
            }
        }
    }
}

struct BranchCreationView_Previews: PreviewProvider {
                            
    static var previews: some View {
        BranchCreationView(
            presented: .constant(false),
            name: .constant(""),
            chat: .constant(Chat()))
        .environmentObject(ChatInteractor.mock)
    }
}
