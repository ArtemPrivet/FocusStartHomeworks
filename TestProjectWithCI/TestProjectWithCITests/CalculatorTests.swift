//
//  TestProjectWithCITests.swift
//  TestProjectWithCITests
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

import XCTest
@testable import TestProjectWithCI

class CalculatorTests: XCTestCase
{
    // MARK: - Тестируемые объекты
    var calculator: Calculator!

    // MARK: - Настройки до/после тестов
    override func setUp() {
        super.setUp()
        self.calculator = Calculator()
    }
    override func tearDown() {
        self.calculator = nil
        super.tearDown()
    }

    // MARK: - Тесты
    func testCalculation() {
        let result = self.calculator.calculate()
        let expectedResult = 0
        XCTAssertEqual(result, expectedResult)
    }
}
