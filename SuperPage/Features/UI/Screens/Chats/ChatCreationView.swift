//
//  ChatCreationViewe.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/31/23.
//

import Foundation
import SwiftUI

struct ChatCreationView: View {
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @Binding var presented: Bool
    
    @Binding var name: String
    
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
                    
                    Text("Create Folder")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                FieldNameTextField(text: $name, placeholder: "Folder name...")
                    .onSubmitName {
                        guard !name.isEmpty else { return }
                        chatInt.createChat(name: name)
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

struct ChatCreationView_Previews: PreviewProvider {
                            
    static var previews: some View {
        ChatCreationView(presented: .constant(false), name: .constant(""))
            .environmentObject(ChatInteractor.mock)
    }
}
