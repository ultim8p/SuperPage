//
//  MessageContent.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/7/24.
//

import Foundation

struct MessageContent: Codable, Equatable {
    
    enum ContentType: String, Codable, Equatable {
        
        case text
        
        case image
    }
    
    var type: ContentType?
    
    var texts: [String]?
    
    var images: [MessageContentImage]?
}
