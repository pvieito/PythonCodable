//
//  PythonDecoder.swift
//  PythonCodable
//
//  Created by Pedro José Pereira Vieito on 11/12/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import PythonKit
import MoreCodable

public struct PythonDecoder {
    static func decode<T: Decodable>(_ type: T.Type, from pythonObject: PythonObject) throws -> T {
        let decodableDictionary = try pythonObject.bridgeToDecodableDictionary()
        return try DictionaryDecoder().decode(type, from: decodableDictionary)
    }
}

extension PythonObject {
    func bridgeToDecodableDictionaryKey() throws -> String {
        guard self.isPythonString else {
            throw PythonError.invalidCall(self)
        }
        
        return String(self)!
    }
    
    func bridgeToDecodableDictionaryValue() throws -> Any? {
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
        else if self.isPythonDictionary {
            return try self.bridgeToDecodableDictionary()
        }
        else {
            throw PythonError.invalidCall(self)
        }
    }
    
    func bridgeToDecodableDictionary() throws -> Dictionary<String, Any?> {
        let pythonDictionary = try self.convertToPythonDictionary()
        var bridgedDictionary: [String : Any?] = [:]
        
        for item in pythonDictionary.items() {
            let (key, value) = item.tuple2
            
            let bridgedKey = try key.bridgeToDecodableDictionaryKey()            
            if let bridgedValue = try value.bridgeToDecodableDictionaryValue() {
                bridgedDictionary[bridgedKey] = bridgedValue
            }
        }
        
        return bridgedDictionary
    }
}

extension PythonObject {
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
        else {
            throw PythonError.invalidCall(self)
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
    
    var isPythonDictionary: Bool {
        return Bool(Python.isinstance(pythonObject, Python.dict))!
    }
    
    var isPythonNone: Bool {
        return Bool(Python.isinstance(pythonObject, Python.type(Python.None)))!
    }
}
