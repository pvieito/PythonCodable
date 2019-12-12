#
#  PythonCodableTestsClass.swift
#  PythonCodableTests
#
#  Created by Pedro José Pereira Vieito on 12/12/2019.
#  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
#

from typing import *

class Struct:
    class SubStruct:
        class SubSubStruct:
            def __init__(self, string: str):
                self.string = string


        def __init__(
            self,
            bool: bool,
            string: str = None,
            double: float = None,
            float: float = None,
            int: int = None,
            intArray: List[int] = None,
            stringArrayArray: List[List[str]] = None,
            subSubStruct: SubSubStruct = None):
            self.bool = bool
            self.string = string
            self.double = double
            self.float = float
            self.int = int
            self.intArray = intArray
            self.stringArrayArray = stringArrayArray
            self.subSubStruct = subSubStruct
            
    def __init__(
        self,
        int: int,
        string: str = None,
        bool: bool = None,
        subStruct: SubStruct = None):
        self.int = int
        self.string = string
        self.bool = bool
        self.subStruct = subStruct
