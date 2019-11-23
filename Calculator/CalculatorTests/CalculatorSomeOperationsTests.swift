//
//  CalculatorSomeOperationsTests.swift
//  CalculatorTests
//
//  Created by Arkadiy Grigoryanc on 23.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

final class CalculatorSomeOperationsTests: XCTestCase
{
	private var calculator = CalculatorEngine()
	private let firstOperand: Double = 1
	private let secondOperand: Double = 2
	private let thirdOperand: Double = 3
	private let forthOperand: Double = 4
	private let fifthOperand: Double = 5
	private let sixthOperand: Double = 6
	private let thirtySecond: Double = 32

	func testOnePlusTwoMultipleThreeOperation() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 * -> 3
		calculator.performOperation(with: .multiple) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand)
		}
		// 1 + 2 * 3
		calculator.setOperand(thirdOperand)
		// 1 + 2 * 3 = -> 7
		calculator.performOperation(with: .equals) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand * thirdOperand)
		}
	}

	func testManyOperationsOperation() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 * -> 3
		calculator.performOperation(with: .multiple) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand)
		}
		// 1 + 2 * 3
		calculator.setOperand(thirdOperand)
		// 1 + 2 * 3 - -> 7
		calculator.performOperation(with: .minus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand * thirdOperand)
		}
		// 1 + 2 * 3 - 4
		calculator.setOperand(forthOperand)
		// 1 + 2 * 3 - 4 / -> 3
		calculator.performOperation(with: .divide) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand * thirdOperand - forthOperand)
		}
		// 1 + 2 * 3 - 4 / 5
		calculator.setOperand(fifthOperand)
		// 1 + 2 * 3 - 4 / 5 * -> 6.2
		calculator.performOperation(with: .multiple) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand * thirdOperand - forthOperand / fifthOperand)
		}
		// 1 + 2 * 3 - 4 / 5 * 6
		calculator.setOperand(sixthOperand)
		// 1 + 2 * 3 - 4 / 5 * 6 -> 2.2
		calculator.performOperation(with: .equals) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand * thirdOperand - forthOperand / fifthOperand * sixthOperand)
		}
	}

	func testOnePlusTwoMultiplePercentOperation() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 * -> 3
		calculator.performOperation(with: .multiple) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand)
		}
		// 1 + 2 * % -> 0.06
		calculator.performOperation(with: .percent) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, (firstOperand + secondOperand) / 100 * secondOperand)
		}
		// 1 + 2 * % = -> 1.12
		calculator.performOperation(with: .equals) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand * ((firstOperand + secondOperand) / 100 * secondOperand))
		}
	}

	func testOnePlusTwoMinusPercentOperation() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 - -> 3
		calculator.performOperation(with: .minus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand)
		}
		// 1 + 2 - % -> 0.06
		calculator.performOperation(with: .percent) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, (firstOperand + secondOperand) / 100 * secondOperand)
		}
		// 1 + 2 - % = -> 2.94
		calculator.performOperation(with: .equals) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand - ((firstOperand + secondOperand) / 100 * secondOperand))
		}
	}

	func testMultiOperationsWithMagnitudeAfterOperator1() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 * -> 2
		calculator.performOperation(with: .multiple) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand)
		}
		// 1 + 2 * +/- -> -0
		calculator.performOperation(with: .magnitude) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, -0)
		}
		// 1 + 2 * +/- 3
		calculator.setOperand(-thirdOperand)
		// 1 + 2 * +/- 3 = -> -5
		calculator.performOperation(with: .equals) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand * -thirdOperand)
		}
	}

	func testMultiOperationsWithMagnitudeAfterOperator2() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 - -> 2
		calculator.performOperation(with: .minus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand)
		}
		// 1 + 2 - +/- -> -0
		calculator.performOperation(with: .magnitude) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, -0)
		}
		// 1 + 2 - +/- 3
		calculator.setOperand(-thirdOperand)
		// 1 + 2 - +/- 3 = -> 6
		calculator.performOperation(with: .equals) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand - -thirdOperand)
		}
	}

	func testMultiOperationsWithMagnitudeAfterOperand() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 * -> 2
		calculator.performOperation(with: .multiple) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand)
		}
		// 1 + 2 * 3
		calculator.setOperand(thirdOperand)
		// 1 + 2 * 3 +/- -> -3
		calculator.performOperation(with: .magnitude) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, -thirdOperand)
		}
		// 1 + 2 * 3 +/- = -> -5
		calculator.performOperation(with: .equals) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand * -thirdOperand)
		}
	}

	func testMultiOperationsWithMagnitudeBetweenOperands() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 + -> 2
		calculator.performOperation(with: .plus) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand)
		}
		// 1 + 2 + 3
		calculator.setOperand(thirdOperand)
		// 1 + 2 + 3 +/- -> -3
		calculator.performOperation(with: .magnitude) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, -thirdOperand)
		}
		// 1 + 2 + 3 +/- -32
		calculator.setOperand(-thirtySecond)
		// 1 + 2 + 3 +/- -32 = -> -29
		calculator.performOperation(with: .equals) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand + secondOperand + -thirtySecond)
		}
	}
}

extension CalculatorSomeOperationsTests
{
	func accumulator(from result: CalculatorEngine.Response) -> CalculatorEngine.CalculateResult {
		guard case .success(let accumulator) = result else {
			// swiftlint:disable:next xctfail_message
			XCTFail()
			return Double()
		}
		return accumulator
	}
}
