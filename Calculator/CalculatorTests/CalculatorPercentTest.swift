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
	private let one: Double = 1
	private let two: Double = 2
	private let three: Double = 3

	func test1() {
		calculator.setOperand(two)
		calculator.performOperation(with: .plus) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.two)
		}
		calculator.setOperand(three)
		calculator.performOperation(with: .percent) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.three / 100 * self.two)
		}
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.two + (self.three / 100 * self.two))
		}
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.two + ((self.three / 100 * self.two) * 2))
		}
	}

	func test2() {
		calculator.setOperand(two)
		calculator.performOperation(with: .plus) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.two)
		}
		calculator.performOperation(with: .percent) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.two / 100 * self.two)
		}
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.two + (self.two / 100 * self.two))
		}
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.two + ((self.two / 100 * self.two) * 2))
		}
	}

	func test3() {
		calculator.setOperand(two)
		calculator.performOperation(with: .plus) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.two)
		}
		calculator.setOperand(three)
		calculator.performOperation(with: .percent) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.three / 100 * self.two)
		}
		calculator.performOperation(with: .magnitude) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, -(self.three / 100 * self.two))
		}
		calculator.setOperand(one)
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.two + self.one)
		}
		calculator.performOperation(with: .equals) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.two + self.one * 2)
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
