//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Artem Orlov on 15/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

final class CalculatorSingleBinaryOperationsTests: XCTestCase
{
	private var calculator = CalculatorEngine()
	private let firstOperand: Double = 1
	private let secondOperand: Double = 2

	func testSinglePlusOperation() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .plus) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand)
		}
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand + self.secondOperand)
		}
		calculator.allClean()
	}

	func testSingleMinusOperation() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .minus) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand)
		}
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand - self.secondOperand)
		}
		calculator.allClean()
	}

	func testSingleMultipleOperation() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .multiple) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand)
		}
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand * self.secondOperand)
		}
		calculator.allClean()
	}

	func testSingleDivideOperation() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .divide) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand)
		}
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand / self.secondOperand)
		}
		calculator.allClean()
	}
}

extension CalculatorSingleBinaryOperationsTests
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
