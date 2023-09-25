//
//  Date+Formatter.swift
//  BotNotes
//
//  Created by Guerson Perez on 3/24/23.
//

import Foundation

//*********************************
//
//  ISODates
//
//*********************************
extension Formatter {
    static var mongoFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime,
                                   .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
}

extension Date {
    var mongoDate: String {
        return Formatter.mongoFormatter.string(from: self)
    }
}

extension String {
    var dateFromMongo: Date? {
        return Formatter.mongoFormatter.date(from: self)
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static let mongoStrategy = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = Formatter.mongoFormatter.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container,
                  debugDescription: "Invalid date: " + string)
        }
        return date
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static let mongoStrategy = custom {
        var container = $1.singleValueContainer()
        try container.encode(Formatter.mongoFormatter.string(from: $0))
    }
}

extension JSONDecoder {
    
    static var mongoDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .mongoStrategy
        return decoder
    }
}

extension JSONEncoder {
    
    static var mongoEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .mongoStrategy
        return encoder
        
    }
}
