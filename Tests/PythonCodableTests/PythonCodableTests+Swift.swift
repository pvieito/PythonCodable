//
//  PythonCodableTests+Swift.swift
//  PythonCodableTests
//
//  Created by Pedro José Pereira Vieito on 12/12/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import FoundationKit
import PythonKit

extension PythonCodableTests {
    struct Struct: Codable, Equatable {
        struct SubStruct: Codable, Equatable {
            struct SubSubStruct: Codable, Equatable {
                let string: String
            }

            let bool: Bool
            let string: String?
            let double: Double?
            let float: Double?
            let int: Int?
            let intArray: Array<Int>?
            let stringArrayArray: Array<Array<String?>>?
            let subSubStruct: SubSubStruct?

            init(
                bool: Bool,
                string: String? = nil,
                double: Double? = nil,
                float: Double? = nil,
                int: Int? = nil,
                intArray: Array<Int>? = nil,
                stringArrayArray: Array<Array<String?>>? = nil,
                subSubStruct: SubSubStruct? = nil) {
                self.bool = bool
                self.string = string
                self.double = double
                self.float = float
                self.int = int
                self.intArray = intArray
                self.stringArrayArray = stringArrayArray
                self.subSubStruct = subSubStruct
            }
        }

        let int: Int
        let string: String?
        let bool: Bool?
        let subStruct: SubStruct?

        init(
            int: Int,
            string: String? = nil,
            bool: Bool? = nil,
            subStruct: SubStruct? = nil) {
            self.int = int
            self.string = string
            self.bool = bool
            self.subStruct = subStruct
        }
    }

    struct Struct2: Codable, Equatable {
        let arrayOfStructs: [Struct]?
        let arrayOfDicts: [[String: String]]?

        init(
            arrayOfStructs: [Struct]? = nil,
            arrayOfDicts: [[String: String]]? = nil) {
            self.arrayOfStructs = arrayOfStructs
            self.arrayOfDicts = arrayOfDicts
        }
    }
}
