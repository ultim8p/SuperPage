//
//  ModelLoadingState.swift
//  SuperPage
//
//  Created by Guerson Perez on 8/7/23.
//

import Foundation

enum ModelState: Codable, Equatable {
    
    case none
    case loading
    case error(Error)

    // MARK: - Codable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .none
            return
        }

        if let loadingString = try? container.decode(String.self), loadingString == "loading" {
            self = .loading
            return
        }

        if let errorMessage = try? container.decode(String.self) {
            let customError = CustomError(localizedDescription: errorMessage)
            self = .error(customError)
            return
        }

        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to decode ModelLoadingState")
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .none:
            try container.encodeNil()
        case .loading:
            try container.encode("loading")
        case .error(let error):
            try container.encode(error.localizedDescription)
        }
    }
    
    // MARK: - Equatable
    
    static func == (lhs: ModelState, rhs: ModelState) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none), (.loading, .loading):
                return true
            case (.error, .error):
                // Comparing error descriptions, which may not be ideal for all use cases.
                return (lhs.localizedDescription == rhs.localizedDescription)
            default:
                return false
            }
        }

        private var localizedDescription: String? {
            switch self {
            case .error(let error):
                return error.localizedDescription
            default:
                return nil
            }
        }
}

struct CustomError: Error {
    var localizedDescription: String
}
