//
//  CalculatorClearTests.swift
//  CalculatorTests
//
//  Created by Arkadiy Grigoryanc on 24.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

final class CalculatorClearTests: XCTestCase
{
	private var calculator = CalculatorEngine()
	private let firstOperand: Double = 1
	private let secondOperand: Double = 2
	private let thirdOperand: Double = 3
	private let forthOperand: Double = 4
	private let fifthOperand: Double = 5
	private let sixthOperand: Double = 6
	private let thirtySecond: Double = 32

	func testClearOperand() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 C
		calculator.clean()
		// 1 + 2 C 3
		calculator.setOperand(thirdOperand)
		// 1 + 2 C 3 * -> 4
		calculator.performOperation(with: .multiple) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand + self.thirdOperand)
		}
		// 1 + 2 C 3 * 4
		calculator.setOperand(forthOperand)
		// 1 + 2 C 3 * 4 = -> 13
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand + self.thirdOperand * self.forthOperand)
		}
	}

	func testClearOperator() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 * -> 3
		calculator.performOperation(with: .multiple) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand + self.secondOperand)
		}
		// 1 + 2 * C
		calculator.clean()
		// 1 + 2 * C 3
		calculator.setOperand(thirdOperand)
		// 1 + 2 * C 3 = -> 7
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand + self.secondOperand * self.thirdOperand)
		}
	}
}

extension CalculatorClearTests
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
