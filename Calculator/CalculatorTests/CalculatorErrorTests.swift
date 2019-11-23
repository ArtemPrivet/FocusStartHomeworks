//
//  CalculatorErrorTests.swift
//  CalculatorTests
//
//  Created by Arkadiy Grigoryanc on 24.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

// swiftlint:disable xctfail_message
final class CalculatorErrorTests: XCTestCase
{
	private var calculator = CalculatorEngine()
	private let zeroOperand: Double = 0
	private let firstOperand: Double = 1
	private let secondOperand: Double = 2
	private let thirdOperand: Double = 3
	private let forthOperand: Double = 4
	private let fifthOperand: Double = 5
	private let sixthOperand: Double = 6
	private let thirtySecond: Double = 32

	func testDivideByZero() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 / -> 1
		calculator.performOperation(with: .divide) { result in
			let result = accumulator(from: result)
			XCTAssertEqual(result, firstOperand)
		}
		// 1 / 0
		calculator.setOperand(zeroOperand)
		// 1 / 0 = -> Ошибка
		calculator.performOperation(with: .multiple) { result in
			XCTAssertEqual(.infinity, firstOperand / zeroOperand)
			if case .failure(let error) = result {
				switch error {
				case .error(message: let message):
					XCTAssertNotNil(error, message)
				}
			}
			else {
				XCTFail()
			}
		}
	}
}

extension CalculatorErrorTests
{
	func accumulator(from result: CalculatorEngine.Response) -> CalculatorEngine.CalculateResult {
		guard case .success(let accumulator) = result else {
			XCTFail()
			return Double()
		}
		return accumulator
	}
}
