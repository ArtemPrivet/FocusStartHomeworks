//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Artem Orlov on 15/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

final class CalculatorTests: XCTestCase
{
	private let calculator = Calculator()

	func testSolvingExpression() {
		let expression = ["5", "+", "3", "*", "2"]
		let result = calculator.solve(input: expression)
		let expectedResult = 11.0
		XCTAssertEqual(result, expectedResult)
	}
	func testSolvingHardExpression() {
		let expression = ["5", "+", "3", "*", "2", "+", "10", "/", "3"]
		let result = calculator.solve(input: expression)
		let expectedResult = 14.333333333333334
		XCTAssertEqual(result, expectedResult)
	}
	func testToRPN() {
		let expression = ["5", "+", "3", "*", "2", "-", "8", "/", "6"]
		let expectedResult = ["5", "3", "2", "*", "+", "8", "6", "/", "-"]
		let result = calculator.toReversePolishNotation(inputArray: expression)
		XCTAssertEqual(result, expectedResult)
	}
	func testStackPush() {
		var stack = Stack<Int>()
		stack.push(5)
		stack.push(3)
		let result = stack.toArray
		let expectedResult = [5, 3]
		XCTAssertEqual(result, expectedResult)
	}
	func testStackPop() {
		var stack = Stack<Int>()
		stack.push(5)
		stack.push(3)
		stack.pop()
		let result = stack.toArray
		let expectedResult = [5]
		XCTAssertEqual(result, expectedResult)
	}
}
