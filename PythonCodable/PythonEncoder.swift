//
//  PythonEncoder.swift
//  PythonCodable
//
//  Created by Pedro José Pereira Vieito on 11/12/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import PythonKit
import MoreCodable

public struct PythonEncoder {
    public static func encode<T: Encodable>(pythonType: PythonObject, from object: T) throws -> PythonObject {
        let encodableDictionary = try DictionaryEncoder().encode(object)
        let pythonEncodableKeyValuePairs = try encodableDictionary.bridgeToPythonEncodableKeyValuePairs()
        return pythonType.dynamicallyCall(withKeywordArguments: pythonEncodableKeyValuePairs)
    }
}

extension Dictionary where Key == String {
    func bridgeToPythonEncodableKeyValuePairs() throws -> KeyValuePairs<String, PythonConvertible> {
        var pythonEncodableDictionary: [String: PythonConvertible] = [:]
        
        for (key, value) in self {
            let pythonValue: PythonObject
            
            if let value = value as? String {
                pythonValue = PythonObject(value)
            }
            else if let value = value as? Bool {
                pythonValue = PythonObject(value)
            }
            else if let value = value as? Int {
                pythonValue = PythonObject(value)
            }
            else if let value = value as? Double {
                pythonValue = PythonObject(value)
            }
            else if value == nil {
                pythonValue = Python.None
            }
            else {
                throw PythonError.invalidCall(Python.None)
            }
            
            pythonEncodableDictionary[key] = PythonObject(pythonValue)
        }
        
        let KeyValuePairs_ = unsafeBitCast(
            KeyValuePairs<Any, Any>.init(dictionaryLiteral:),
            to: (([(Any, Any)]) -> KeyValuePairs<String, PythonConvertible>).self)
        return KeyValuePairs_(Array(pythonEncodableDictionary))
    }
}

