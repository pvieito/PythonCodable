import XCTest
import PythonKit
@testable import PythonCodable

final class PythonCodableTests: XCTestCase {
    struct SwiftTestStruct: Codable, Equatable {
        struct Substruct: Codable, Equatable {
            struct Subsubstruct: Codable, Equatable {
                let string: String
            }
            
            let bool: Bool
            let string: String?
            let double: Double?
            let float: Double?
            let int: Int?
            let subsubstruct: Subsubstruct?
            
            init(
                bool: Bool,
                string: String? = nil,
                double: Double? = nil,
                float: Double? = nil,
                int: Int? = nil,
                subsubstruct: Subsubstruct? = nil) {
                self.bool = bool
                self.string = string
                self.double = double
                self.float = float
                self.int = int
                self.subsubstruct = subsubstruct
            }
        }
        
        let a: Int
        let b: String?
        let c: Bool?
        let substruct: Substruct?
        
        init(
            a: Int,
            b: String? = nil,
            c: Bool? = nil,
            substruct: Substruct? = nil) {
            self.a = a
            self.b = b
            self.c = c
            self.substruct = substruct
        }
    }
    
    static func decodeSwiftTestStruct(pythonObject: PythonObject) throws -> SwiftTestStruct {
        return try PythonDecoder.decode(SwiftTestStruct.self, from: pythonObject)
    }
    
    func testPythonDecoder() throws {
        let pyA = try Self.decodeSwiftTestStruct(pythonObject: PythonObject([
            "a": 1,
            "b": "asb"]))
        let swA = SwiftTestStruct(
            a: 1,
            b: "asb")
        XCTAssertEqual(pyA, swA)
        
        let pyB = try! Self.decodeSwiftTestStruct(pythonObject: PythonObject([
            "a": -1993_03_20,
            "b": "_PedroJoséPereiraVieito_ ÑÇÈ$",
            "c": false,
            "_fake_": "454"]))
        let swB = SwiftTestStruct(
            a: -1993_03_20,
            b: "_PedroJoséPereiraVieito_ ÑÇÈ$",
            c: false)
        XCTAssertEqual(pyB, swB)
        
        let pyC = try! Self.decodeSwiftTestStruct(pythonObject: PythonObject([
            "a": 0,
            "b": Python.None,
            "c": true,
            "_fake_": "454"]))
        let swC = SwiftTestStruct(
            a: 0,
            c: true)
        XCTAssertEqual(pyC, swC)
        
        let pyD = try! Self.decodeSwiftTestStruct(pythonObject: PythonObject([
                "a": 0,
                "substruct": [
                    "bool": Python.True,
                    "string": "123",
                    "subsubstruct": ["string": "0987"],
                    "double": 1.334,
                    "float": 1.9876
                ],
                "_fake_": "454"
            ]))
        let swD = SwiftTestStruct(
            a: 0,
            substruct: .init(
                bool: true,
                string: "123",
                double: 1.334,
                float: 1.9876,
                subsubstruct: .init(string: "0987")
            ))
        XCTAssertEqual(pyD, swD)
    }
    
    func testPythonDecoderFailures() throws {
        XCTAssertThrowsError(try Self.decodeSwiftTestStruct(pythonObject: PythonObject([])))
        XCTAssertThrowsError(try Self.decodeSwiftTestStruct(pythonObject: PythonObject(["b": "TEXT"])))
        XCTAssertThrowsError(try Self.decodeSwiftTestStruct(pythonObject: PythonObject(["a": "TEXT"])))
        XCTAssertThrowsError(try Self.decodeSwiftTestStruct(pythonObject: PythonObject(["a": 1.0])))
        XCTAssertThrowsError(try Self.decodeSwiftTestStruct(pythonObject: PythonObject(["a": 1, "b": 1])))
        XCTAssertThrowsError(try Self.decodeSwiftTestStruct(pythonObject: PythonObject(["a": 1, "b": "TEXT", "substruct": ["bool": "FALSE"]])))
    }
}
