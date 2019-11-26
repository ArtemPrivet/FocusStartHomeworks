//
//  CalculatorPercentTest.swift
//  CalculatorTests
//
//  Created by Arkadiy Grigoryanc on 25.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

final class CalculatorPercentTest: XCTestCase
{
	private var calculator = CalculatorEngine()
	private let firstOperand: Double = 1
	private let secondOperand: Double = 2
	private let thirdOperand: Double = 3

	func test1() {
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .plus) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.secondOperand)
		}
		calculator.setOperand(thirdOperand)
		calculator.performOperation(with: .percent) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.thirdOperand / 100 * self.secondOperand)
		}
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.secondOperand + (self.thirdOperand / 100 * self.secondOperand))
		}
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.secondOperand + ((self.thirdOperand / 100 * self.secondOperand) * 2))
		}
	}

	func test2() {
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .plus) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.secondOperand)
		}
		calculator.performOperation(with: .percent) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.secondOperand / 100 * self.secondOperand)
		}
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.secondOperand + (self.secondOperand / 100 * self.secondOperand))
		}
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.secondOperand + ((self.secondOperand / 100 * self.secondOperand) * 2))
		}
	}

	func test3() {
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .plus) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.secondOperand)
		}
		calculator.setOperand(thirdOperand)
		calculator.performOperation(with: .percent) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.thirdOperand / 100 * self.secondOperand)
		}
		calculator.performOperation(with: .magnitude) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, -(self.thirdOperand / 100 * self.secondOperand))
		}
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.secondOperand + self.firstOperand)
		}
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.secondOperand + self.firstOperand * 2)
		}
	}
}

extension CalculatorPercentTest
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
