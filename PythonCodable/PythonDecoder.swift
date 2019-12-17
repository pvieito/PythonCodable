//
//  PythonDecoder.swift
//  PythonCodable
//
//  Created by Pedro José Pereira Vieito on 11/12/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import PythonKit
import MoreCodable

public struct PythonDecoder {
    /// Tries to decodes the input `pythonObject` into the Swift `type` type.
    /// - Parameters:
    ///   - type: Decodable Swift type.
    ///   - pythonObject: Input Python object.
    public static func decode<T: Decodable>(_ type: T.Type, from pythonObject: PythonObject) throws -> T {
        let decodableDictionary = try pythonObject.bridgeToDecodableDictionary()
        return try DictionaryDecoder().decode(type, from: decodableDictionary)
    }
}

extension PythonObject {
    /// Tries to bridge the `PythonObject` into an equivalent Swift type.
    public func bridgeToSwift() throws -> Any? {
        return try self.bridgeToDecodableValue()
    }
}

extension PythonDecoder {
    enum Error: Swift.Error {
        case unsupportedType
        case unsupportedListType
        case unsupportedDictionaryType
    }
}

extension PythonObject {
    func bridgeToDecodableDictionaryKey() throws -> String {
        guard self.isPythonString else {
            throw PythonError.invalidCall(self)
        }
        
        return String(self)!
    }
    
    func bridgeToDecodableValue() throws -> Any? {
        if self.isPythonString {
            return String(self)!
        }
        else if self.isPythonBool {
            return Bool(self)!
        }
        else if self.isPythonInteger {
            return Int(self)!
        }
        else if self.isPythonFloat {
            return Double(self)!
        }
        else if self.isPythonNone {
            return nil
        }
        else if self.isPythonListOrListConvertible {
            return try self.bridgeToDecodableArray()
        }
        else if self.isPythonDictionaryOrDictionaryConvertible {
            return try self.bridgeToDecodableDictionary()
        }
        else {
            throw PythonDecoder.Error.unsupportedType
        }
    }
    
    func bridgeToDecodableArray() throws -> Array<Any?> {
        let pythonList = try self.convertToPythonList()
        var bridgedArray: [Any?] = []
        
        for item in pythonList {
            let bridgedValue = try item.bridgeToDecodableValue()
            bridgedArray.append(bridgedValue)
        }
        
        return bridgedArray
    }
    
    func bridgeToDecodableDictionary() throws -> Dictionary<String, Any> {
        let pythonDictionary = try self.convertToPythonDictionary()
        var bridgedDictionary: [String : Any] = [:]
        
        for item in pythonDictionary.items() {
            let (key, value) = item.tuple2
            
            if key.isPythonString, let bridgedValue = try value.bridgeToDecodableValue() {
                bridgedDictionary[String(key)!] = bridgedValue
            }
        }
        
        return bridgedDictionary
    }
}

extension PythonObject {
    var isPythonListOrListConvertible: Bool {
        return self.isPythonList || self.isPythonListConvertible
    }
    
    var isPythonListConvertible: Bool {
        return Bool(Python.hasattr(self, "__iter__"))!
    }
    
    func convertToPythonList() throws -> PythonObject {
        if self.isPythonList {
            return self
        }
        else if self.isPythonListConvertible {
            return Python.list(pythonObject)
        }
        else {
            throw PythonDecoder.Error.unsupportedListType
        }
    }
}

extension PythonObject {
    var isPythonDictionaryOrDictionaryConvertible: Bool {
        return self.isPythonDictionary || self.isPythonDictionaryConvertible
    }
    
    var isPythonNamedTupleConvertible: Bool {
        return Bool(Python.hasattr(self, "_asdict"))!
    }
    
    var isPythonDictionaryConvertible: Bool {
        return Bool(Python.hasattr(self, "__dict__"))!
    }
    
    func convertToPythonDictionary() throws -> PythonObject {
        if self.isPythonDictionary {
            return self
        }
        else if self.isPythonDictionaryConvertible {
            return Python.vars(pythonObject)
        }
        else if self.isPythonNamedTupleConvertible {
            return Python.dict(pythonObject._asdict())
        }
        else {
            throw PythonDecoder.Error.unsupportedDictionaryType
        }
    }
}

extension PythonObject {
    var isPythonString: Bool {
        return Bool(Python.isinstance(pythonObject, Python.str))!
    }
    
    var isPythonInteger: Bool {
        return Bool(Python.isinstance(pythonObject, Python.int))!
    }
    
    var isPythonFloat: Bool {
        return Bool(Python.isinstance(pythonObject, Python.float))!
    }
    
    var isPythonBool: Bool {
        return Bool(Python.isinstance(pythonObject, Python.bool))!
    }
    
    var isPythonList: Bool {
        return Bool(Python.isinstance(pythonObject, Python.list))!
    }
    
    var isPythonDictionary: Bool {
        return Bool(Python.isinstance(pythonObject, Python.dict))!
    }
    
    var isPythonNone: Bool {
        return Bool(Python.isinstance(pythonObject, Python.type(Python.None)))!
    }
}
