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
	let calculationsWithOneNumber: [(operand: Double, operation: String, result: Double)] = [
		(800, "%", 8),
		(87, "+/-", -87),
	]

	let calculationsWithTwoNumbers: [(firstOperand: Double,
									operation: String,
									secondOperand: Double,
									resultOperation: String,
									result: Double)] = [
		(2.4, "✕", 6.4, "＝", 2.4 * 6.4),
		(8.32, "＋", 1, "＝", 8.32 + 1),
		(12, "÷", 3, "＝", 12 / 3),
		(2793, "－", 1628, "＝", 2793 - 1628),
		(8, "＋", 89, "＋", 8 + 89),
		(200, "＋", 5, "%", 200 * 0.05),
	]

	let calculationsWithPercents: [(firstOperand: Double,
									operation: String,
									secondOperand: Double,
									resultOperation: String,
									equals: String,
									result: Double)] = [
		(200, "＋", 5, "%", "＝", 200 + 200 * 0.05),
	]

	let calculationsWithThreeNumbers: [(firstOperand: Double,
									firstOperation: String,
									secondOperand: Double,
									secondOperation: String,
									thirdOperand: Double,
									resultOperation: String,
									result: Double)] = [
		(2, "＋", 2, "✕", 2, "＝", 2.0 + 2.0 * 2.0),
		(1, "＋", 2, "÷", 3, "＝", 1 + 2 / 3),
		(1.23, "＋", 2.9, "－", 3, "＝", 1.23 + 2.9 - 3),
		(4, "✕", 2, "－", 3, "＝", 4 * 2 - 3),
		(4.5, "✕", 982, "÷", 0.5, "＝", 4.5 * 982 / 0.5),
	]
	let calculationsWithFourNumbers: [(firstOperand: Double,
									firstOperation: String,
									secondOperand: Double,
									secondOperation: String,
									thirdOperand: Double,
									thirdOperation: String,
									fourthOperand: Double,
									resultOperation: String,
									result: Double)] = [
		(1, "＋", 2, "✕", 4, "÷", 3, "＝", 1 + 2 * 4 / 3),
		(1, "✕", 2, "✕", 4, "＋", 3, "＝", 1 * 2 * 4 + 3),
		(8, "＋", 2, "✕", 9, "＋", 1, "＝", 8 + 2 * 9 + 1),
	]

	func testOperationsWithOneNumber() {
		calculationsWithOneNumber.forEach{
			let calculations = Calculations()
			calculations.setOperand(operand: $0.operand)
			calculations.makeOperation(symbol: $0.operation)
			XCTAssertEqual(calculations.result, $0.result)
		}
	}
	func testOperationsWithTwoNumbers() {
		calculationsWithTwoNumbers.forEach{
			let calculations = Calculations()
			calculations.setOperand(operand: $0.firstOperand)
			calculations.makeOperation(symbol: $0.operation)
			calculations.setOperand(operand: $0.secondOperand)
			calculations.makeOperation(symbol: $0.resultOperation)
			XCTAssertEqual(calculations.result, $0.result)
		}
	}
	func testOperationsWithPercents() {
		calculationsWithPercents.forEach{
			let calculations = Calculations()
			calculations.setOperand(operand: $0.firstOperand)
			calculations.makeOperation(symbol: $0.operation)
			calculations.setOperand(operand: $0.secondOperand)
			calculations.makeOperation(symbol: $0.resultOperation)
			calculations.makeOperation(symbol: $0.equals)
			XCTAssertEqual(calculations.result, $0.result)
		}
	}
	func testOperationsWithThreeNumbers() {
		calculationsWithThreeNumbers.forEach{
			let calculations = Calculations()
			calculations.setOperand(operand: $0.firstOperand)
			calculations.makeOperation(symbol: $0.firstOperation)
			calculations.setOperand(operand: $0.secondOperand)
			calculations.makeOperation(symbol: $0.secondOperation)
			calculations.setOperand(operand: $0.thirdOperand)
			calculations.makeOperation(symbol: $0.resultOperation)
			XCTAssertEqual(calculations.result, $0.result)
		}
	}
	func testOperationsWithFourNumbers() {
		calculationsWithFourNumbers.forEach{
			let calculations = Calculations()
			calculations.setOperand(operand: $0.firstOperand)
			calculations.makeOperation(symbol: $0.firstOperation)
			calculations.setOperand(operand: $0.secondOperand)
			calculations.makeOperation(symbol: $0.secondOperation)
			calculations.setOperand(operand: $0.thirdOperand)
			calculations.makeOperation(symbol: $0.thirdOperation)
			calculations.setOperand(operand: $0.fourthOperand)
			calculations.makeOperation(symbol: $0.resultOperation)
			XCTAssertEqual(calculations.result, $0.result)
		}
	}
}
