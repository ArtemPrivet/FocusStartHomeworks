//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Artem Orlov on 15/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

// swiftlint:disable xctfail_message
final class CalculatorSingleBinaryOperationsTests: XCTestCase
{
	private var calculator = CalculatorEngine()
	private let firstOperand: Double = 1
	private let secondOperand: Double = 2

	func testSinglePlusOperation() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .plus) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand)
		}
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .equals) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand)
		}
		calculator.allClean()
	}

	func testSingleMinusOperation() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .minus) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand)
		}
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .equals) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand - secondOperand)
		}
		calculator.allClean()
	}

	func testSingleMultipleOperation() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .multiple) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand)
		}
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .equals) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand * secondOperand)
		}
		calculator.allClean()
	}

	func testSingleDivideOperation() {
		calculator.setOperand(firstOperand)
		calculator.performOperation(with: .divide) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand)
		}
		calculator.setOperand(secondOperand)
		calculator.performOperation(with: .equals) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand / secondOperand)
		}
		calculator.allClean()
	}
}
