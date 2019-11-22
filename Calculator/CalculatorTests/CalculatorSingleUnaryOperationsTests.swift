//
//  CalculatorSingleUnaryOperationsTests.swift
//  CalculatorTests
//
//  Created by Arkadiy Grigoryanc on 22.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

// swiftlint:disable xctfail_message
final class CalculatorSingleUnaryOperationsTests: XCTestCase
{
	private var calculator = CalculatorEngine()
	private let firstOperand: Double = 1
	//private let secondOperand: Double = 2

	func testSinglePlusOperation() {
		var magnituded: Double = 0
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .magnitude) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}

			XCTAssertEqual(accumulator, -firstOperand)
			magnituded = accumulator
		}
		calculator.performOperation(with: .magnitude) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, -magnituded)
		}
	}
}
