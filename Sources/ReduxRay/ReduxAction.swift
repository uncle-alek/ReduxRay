//
//  ReduxAction.swift
//  
//
//  Created by Aleksey Yakimenko on 15/8/22.
//

import Foundation

struct ReduxAction<Action, State>: Encodable where State: Encodable {
    let action: Action
    let stateBefore: State
    let stateAfter: State
    let file: String?
    let line: UInt?
    
    enum CodingKeys: String, CodingKey {
        case name
        case timestamp
        case stateBefore
        case stateAfter
        case file
        case line
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(atomEnum(action)!, forKey: .name)
        try container.encode(Date().timeIntervalSince1970, forKey: .timestamp)
        try container.encode(try JSONEncoder().encode(stateBefore).toUtf8String(), forKey: .stateBefore)
        try container.encode(try JSONEncoder().encode(stateAfter).toUtf8String(), forKey: .stateAfter)
        try container.encode(file, forKey: .file)
        try container.encode(line, forKey: .line)
    }
    
    func encodeToUtf8String() -> String? {
        try? JSONEncoder().encode(self).toUtf8String()
    }
    
    func atomEnum<T>( _ value: T) -> String? {
        guard Mirror(reflecting: value).displayStyle == .enum else { return nil }
        if let children = Mirror(reflecting: value).children.first {
            return atomEnum(children.value) ?? children.label
        }
        return "\(value)"
    }
}

extension Data {
    
    func toUtf8String() -> String? {
        String(data: self, encoding: .utf8)
    }
}
