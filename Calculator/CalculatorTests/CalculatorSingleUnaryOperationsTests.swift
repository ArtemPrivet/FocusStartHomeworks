//
//  CalculatorSingleUnaryOperationsTests.swift
//  CalculatorTests
//
//  Created by Arkadiy Grigoryanc on 22.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

final class CalculatorSingleUnaryOperationsTests: XCTestCase
{
	private var calculator = CalculatorEngine()
	private let firstOperand: Double = 1

	func testSinglePlusOperation() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .magnitude) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, -self.firstOperand)
		}
		calculator.performOperation(with: .magnitude) { result in
			let result = self.accumulator(from: result)
			XCTAssertEqual(result, self.firstOperand)
		}
	}
}

extension CalculatorSingleUnaryOperationsTests
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
