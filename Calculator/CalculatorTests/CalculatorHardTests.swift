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
	private let one: Double = 1
	private let two: Double = 2
	private let three: Double = 3
	private let four: Double = 4
	private let five: Double = 5
	private let six: Double = 6
	private let thirtyTwo: Double = 32

	// 1, +, 2, *, +/-, -3, =   --->   7
	func test1() {
		calculator.setOperand(one)
		calculator.performOperation(with: .plus)
		calculator.setOperand(two)
		calculator.performOperation(with: .multiple)
		calculator.performOperation(with: .magnitude)
		calculator.setOperand(-three)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.one + self.two * -self.three)
		}
	}

	// 1, +, 2, *, +/-, -3, +/-, =   --->   6
	func test2() {
		calculator.setOperand(one)
		calculator.performOperation(with: .plus)
		calculator.setOperand(two)
		calculator.performOperation(with: .multiple)
		calculator.performOperation(with: .magnitude)
		calculator.setOperand(-three)
		calculator.performOperation(with: .magnitude)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.one + self.two * self.three)
		}
	}

	// 1, +, 2, *, +/-, *, =   --->   1
	func test3() {
		calculator.setOperand(one)
		calculator.performOperation(with: .plus)
		calculator.setOperand(two)
		calculator.performOperation(with: .multiple)
		calculator.performOperation(with: .magnitude)
		calculator.performOperation(with: .multiple)
		calculator.setOperand(three)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.one + self.two * self.zero)
		}
	}

	// 1, +, 2, *, +/-, C, 6, =   --->   13
	func test4() {
		calculator.setOperand(one)
		calculator.performOperation(with: .plus)
		calculator.setOperand(two)
		calculator.performOperation(with: .multiple)
		calculator.performOperation(with: .magnitude)
		calculator.clean()
		calculator.setOperand(six)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.one + self.two * self.six)
		}
	}

	// 1, +, 2, *, +/-, C, 6, =, =, =   --->   468
	func test5() {
		calculator.setOperand(one)
		calculator.performOperation(with: .plus)
		calculator.setOperand(two)
		calculator.performOperation(with: .multiple)
		calculator.performOperation(with: .magnitude)
		calculator.clean()
		calculator.setOperand(six)
		calculator.performOperation(with: .equals)
		calculator.performOperation(with: .equals)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, (self.one + self.two * self.six) * self.six * self.six)
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
