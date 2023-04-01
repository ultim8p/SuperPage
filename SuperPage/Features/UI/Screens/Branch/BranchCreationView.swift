//
//  BranchCreationView.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/31/23.
//

import Foundation
import SwiftUI

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
