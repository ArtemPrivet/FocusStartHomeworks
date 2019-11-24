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
	var calc = Calculator()

	func testSetOperand() {
		let operand = 5.0
		calc.setOperand(operand)

		let result = calc.evaluate()

		XCTAssert(result == (operand, false), "Ошибка присвоения операнда")
	}

	func testSetOperandWithOperationSign() {
		let operand = 9.0

		calc.setOperand(operand)
		calc.setOperation(Sign.plus)

		let result = calc.evaluate()

		XCTAssert(result == (nil, true), "Ошибка присвоения операции к единственному операнду")
	}

	func testSetOperandWithOperationSignAndSecondOperand() {
		let operand1 = 9.0
		let operand2 = 2.0

		calc.setOperand(operand1)
		calc.setOperation(Sign.multiply)

		let result = calc.evaluate()

		calc.setOperand(operand2)

		XCTAssert(result == (nil, true), "Результат не должен отображаться пока не нажат знак равенства")
	}

	func testSetOperandWithOperationSignAndSecondOperandEquals() {
		let operand1 = 90.0
		let operand2 = 10.0

		calc.setOperand(operand1)
		calc.setOperation(Sign.divide)

		var result = calc.evaluate()

		calc.setOperand(operand2)

		calc.setOperation(Sign.equals)

		result = calc.evaluate()

		XCTAssert(result == (9.0, false), "Неверный результат или состояние отложенной операции")
	}

	func test1Plus2Divide3Equals() {
		let operand1 = 1.0
		let operand2 = 2.0
		let operand3 = 3.0

		calc.setOperand(operand1)
		calc.setOperation(Sign.plus)
		calc.setOperand(operand2)
		calc.setOperation(Sign.divide)
		calc.setOperand(operand3)
		calc.setOperation(Sign.equals)

		let result = calc.evaluate()

		XCTAssert(result == (1.6666666666666665, false), "Неверный результат или состояние отложенной операции")
	}

	func test200Plus5Percent() {
		calc.setOperand(200.0)
		calc.setOperation(Sign.plus)
		calc.setOperand(5.0)
		calc.setOperation(Sign.percent)

		let result = calc.evaluate()

		XCTAssert(result == (10.0, true), "Неверный результат или состояние отложенной операции")
	}

	func test200Plus5PercentEquals() {
		calc.setOperand(200.0)
		calc.setOperation(Sign.plus)

		var result = calc.evaluate()
		calc.setOperand(5.0)
		calc.setOperation(Sign.percent)
		result = calc.evaluate()

		XCTAssert(result == (10.0, true), "Неверный промежуточный результат или состояние отложенной операции")

		calc.setOperand(10.0)
		calc.setOperation(Sign.equals)
		result = calc.evaluate()

		XCTAssert(result == (210.0, false), "Неверный конечный результат или состояние отложенной операции")
	}

	func testMinus0() {
		let operand = 0.0
		calc.setOperand(operand)
		calc.setOperation(Sign.changeSign)

		let result = calc.evaluate()

		XCTAssert(result == (-operand, false), "Число должно иметь противоположный знак или состояние отложенной операции")
	}
}
