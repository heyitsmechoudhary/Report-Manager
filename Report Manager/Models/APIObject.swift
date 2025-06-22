//
//  APIObject.swift
//  Report Manager
//
//  Created by Rahul choudhary on 22/06/25.
//


import Foundation

struct APIObject: Codable, Identifiable {
    let id: String
    var name: String
    var data: [String: AnyCodable]?
    
    // Helper method to safely convert value to string
    func getFormattedValue(for key: String) -> String {
        guard let value = data?[key]?.value else { return "" }
        
        switch value {
        case let doubleValue as Double:
            // Handle price formatting
            if key.lowercased().contains("price") {
                return String(format: "%.2f", doubleValue)
            }
            return "\(doubleValue)"
        case let intValue as Int:
            return "\(intValue)"
        case let stringValue as String:
            return stringValue
        default:
            return "\(value)"
        }
    }
}

struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.value = ""
            return
        }
        
        do {
            self.value = try container.decode(String.self)
            return
        } catch {}
        
        do {
            self.value = try container.decode(Double.self)
            return
        } catch {}
        
        do {
            self.value = try container.decode(Int.self)
            return
        } catch {}
        
        do {
            self.value = try container.decode(Bool.self)
            return
        } catch {}
        
        self.value = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let string as String:
            try container.encode(string)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let bool as Bool:
            try container.encode(bool)
        case is NSNull:
            try container.encodeNil()
        default:
            try container.encode(String(describing: value))
        }
    }
}
