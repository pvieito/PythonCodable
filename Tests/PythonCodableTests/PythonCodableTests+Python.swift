//
//  PythonCodableTests+Python.swift
//  PythonCodableTests
//
//  Created by Pedro José Pereira Vieito on 12/12/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import PythonKit

extension PythonCodableTests {
    static let pythonModule: PythonObject = {
        let sys = Python.import("sys")
        sys.path.insert(0, testBundle.resourcePath!)
        let PythonCodableTests = Python.import("PythonCodableTests")
        return PythonCodableTests
    }()
}
