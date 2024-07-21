//
//  PythonDecoderTests.swift
//  PythonCodableTests
//
//  Created by Pedro José Pereira Vieito on 11/12/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import XCTest
import PythonKit
import PythonCodable

final class PythonDecoderTests: XCTestCase {
    static func decodeTestStruct(_ pythonObject: PythonObject) throws -> PythonCodableTests.Struct {
        return try PythonDecoder.decode(PythonCodableTests.Struct.self, from: pythonObject)
    }

    static func decodeTestStruct2(_ pythonObject: PythonObject) throws -> PythonCodableTests.Struct2 {
        return try PythonDecoder.decode(PythonCodableTests.Struct2.self, from: pythonObject)
    }

    func testPythonDecoderTestReadmeExample() throws {
        // 1. Get a valid Python object:

        let urllibParse = Python.import("urllib.parse")
        let pythonParsedURL = urllibParse.urlparse("http://www.cwi.nl:80/%7Eguido/Python.html")

        print(pythonParsedURL)               // ParseResult(scheme='http', netloc='www.cwi.nl:80'...
        print(Python.type(pythonParsedURL))  // <class 'urllib.parse.ParseResult'>

        // 2. Define a compatible Swift struct conforming to `Decodable`:

        struct ParsedURL: Decodable {
            let scheme: String
            let netloc: String
            let path: String
            let params: String?
            let query: String?
            let fragment: String?
        }

        // 3. Decode the Python object as a Swift type using `PythonDecoder`:

        let parsedURL = try PythonDecoder.decode(ParsedURL.self, from: pythonParsedURL)

        XCTAssertEqual(parsedURL.scheme, "http")
        XCTAssertEqual(parsedURL.netloc, "www.cwi.nl:80")
        XCTAssertEqual(parsedURL.path, "/%7Eguido/Python.html")

        XCTAssertEqual(parsedURL.params, "")
        XCTAssertEqual(parsedURL.query, "")
        XCTAssertEqual(parsedURL.fragment, "")
    }

    func testPythonDecoderTestStruct() throws {
        let pyA = try Self.decodeTestStruct(PythonCodableTests.pythonModule.Struct(
            int: 1,
            string: "asb"))
        let swA = PythonCodableTests.Struct(
            int: 1,
            string: "asb")
        XCTAssertEqual(pyA, swA)

        let pyB = try Self.decodeTestStruct(PythonObject([
            "int": -1_993_030_200,
            "string": "TEST_å∫∂ƒñ",
            "bool": false,
            "_fake_": "454"]))
        let swB = PythonCodableTests.Struct(
            int: -1_993_030_200,
            string: "TEST_å∫∂ƒñ",
            bool: false)
        XCTAssertEqual(pyB, swB)

        let pyC = try Self.decodeTestStruct(PythonObject([
            "int": 0,
            "string": Python.None,
            "bool": true,
            "_fake_": "454"]))
        let swC = PythonCodableTests.Struct(
            int: 0,
            bool: true)
        XCTAssertEqual(pyC, swC)

        let pyD_SSS = PythonCodableTests.pythonModule.Struct.SubStruct.SubSubStruct(string: "0987")
        let swD_SSS = PythonCodableTests.Struct.SubStruct.SubSubStruct(string: "0987")
        let pyD_SS = PythonCodableTests.pythonModule.Struct.SubStruct(
            subSubStruct: pyD_SSS,
            bool: Python.True,
            string: "123",
            double: 1.334,
            float: 1.9876,
            intArray: [1, 2, 3],
            stringArrayArray: [["stringA"], ["string_text", "3"], [], ["None", Python.None]])
        let swD_SS = PythonCodableTests.Struct.SubStruct(
            bool: true,
            string: "123",
            double: 1.334,
            float: 1.9876,
            intArray: [1, 2, 3],
            stringArrayArray: [["stringA"], ["string_text", "3"], [], ["None", nil]],
            subSubStruct: swD_SSS)
        let pyD_S = PythonCodableTests.pythonModule.Struct(
            int: 0,
            subStruct: pyD_SS)
        let pyD = try Self.decodeTestStruct(pyD_S)
        let swD = PythonCodableTests.Struct(
            int: 0,
            subStruct: swD_SS)
        XCTAssertEqual(pyD, swD)
    }

    func testArrayOfStructs() throws {
        let pyMod = PythonCodableTests.pythonModule
        let pyLS = try Self.decodeTestStruct2(pyMod.Struct2(
            arrayOfStructs: [pyMod.Struct(int: 1), pyMod.Struct(int: 2)]
        ))
        let swLS = PythonCodableTests.Struct2(
            arrayOfStructs: [PythonCodableTests.Struct(int: 1), PythonCodableTests.Struct(int: 2)]
        )
        XCTAssertEqual(pyLS, swLS)
    }

    func testArrayOfDictionaries() throws {
        let pyMod = PythonCodableTests.pythonModule
        let dict1: [String: String] = ["key1": "value1"]
        let dict2: [String: String] = ["key2": "value2"]
        let pyLD = try Self.decodeTestStruct2(pyMod.Struct2(
            arrayOfDicts: [dict1, dict2]
        ))
        let swLD = PythonCodableTests.Struct2(
            arrayOfDicts: [dict1, dict2]
        )
        XCTAssertEqual(pyLD, swLD)
    }

    func testPythonDecoderFailures() throws {
        let decodeFailureObjects = [
            PythonObject([]),
            PythonObject(["string": "TEXT"]),
            PythonObject(["int": "TEXT"]),
            PythonObject(["int": 1.0]),
            PythonObject(["Int": 1]),
            PythonObject(["INT": 1]),
            PythonObject(["int": 1, "string": 1]),
            PythonObject(["int": 1, "string": "TEXT", "subStruct": ["bool": "FALSE"]]),
            PythonObject(["int": 1, "string": "TEXT", "subStruct": ["bool": Python.False, "stringArrayArray": [[1]]]]),
        ]

        for decodeFailureObject in decodeFailureObjects {
            XCTAssertThrowsError(try Self.decodeTestStruct(decodeFailureObject))
        }
    }
}
