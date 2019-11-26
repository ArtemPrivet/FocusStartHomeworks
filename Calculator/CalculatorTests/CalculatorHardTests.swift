//
//  CalculatorHardTests.swift
//  CalculatorTests
//
//  Created by Arkadiy Grigoryanc on 24.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

final class CalculatorHardTests: XCTestCase
{
	private var calculator = CalculatorEngine()
	private let zero: Double = 0
	private let firstOperand: Double = 1
	private let secondOperand: Double = 2
	private let thirdOperand: Double = 3
	private let sixthOperand: Double = 6

	// 1, +, 2, *, +/-, -3, =   --->   7
	func test1() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .plus)
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .multiple)
		calculator.performOperation(with: .magnitude)
		calculator.setOperand(-thirdOperand)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand + self.secondOperand * -self.thirdOperand)
		}
	}

	// 1, +, 2, *, +/-, -3, +/-, =   --->   6
	func test2() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .plus)
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .multiple)
		calculator.performOperation(with: .magnitude)
		calculator.setOperand(-thirdOperand)
		calculator.performOperation(with: .magnitude)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand + self.secondOperand * self.thirdOperand)
		}
	}

	// 1, +, 2, *, +/-, *, =   --->   1
	func test3() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .plus)
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .multiple)
		calculator.performOperation(with: .magnitude)
		calculator.performOperation(with: .multiple)
		calculator.setOperand(thirdOperand)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand + self.secondOperand * self.zero)
		}
	}

	// 1, +, 2, *, +/-, C, 6, =   --->   13
	func test4() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .plus)
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .multiple)
		calculator.performOperation(with: .magnitude)
		calculator.clean()
		calculator.setOperand(sixthOperand)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand + self.secondOperand * self.sixthOperand)
		}
	}

	// 1, +, 2, *, +/-, C, 6, =, =, =   --->   468
	func test5() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .plus)
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .multiple)
		calculator.performOperation(with: .magnitude)
		calculator.clean()
		calculator.setOperand(sixthOperand)
		calculator.performOperation(with: .equals)
		calculator.performOperation(with: .equals)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, (self.firstOperand + self.secondOperand *
				self.sixthOperand) * self.sixthOperand * self.sixthOperand)
		}
	}
}

extension CalculatorHardTests
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
