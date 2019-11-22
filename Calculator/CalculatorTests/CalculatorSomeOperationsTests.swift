//
//  CalculatorSomeOperationsTests.swift
//  CalculatorTests
//
//  Created by Arkadiy Grigoryanc on 23.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

// swiftlint:disable xctfail_message
final class CalculatorSomeOperationsTests: XCTestCase
{
	private var calculator = CalculatorEngine()
	private let firstOperand: Double = 1
	private let secondOperand: Double = 2
	private let thirdOperand: Double = 3
	private let forthOperand: Double = 4
	private let fifthOperand: Double = 5
	private let sixthOperand: Double = 6

	func testOnePlusTwoMultipleThreeOperation() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}

			XCTAssertEqual(accumulator, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 * -> 3
		calculator.performOperation(with: .multiple) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand)
		}
		// 1 + 2 * 3
		calculator.setOperand(thirdOperand)
		// 1 + 2 * 3 = -> 7
		calculator.performOperation(with: .equals) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand * thirdOperand)
		}
	}

	func testManyOperationsOperation() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 * -> 3
		calculator.performOperation(with: .multiple) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand)
		}
		// 1 + 2 * 3
		calculator.setOperand(thirdOperand)
		// 1 + 2 * 3 - -> 7
		calculator.performOperation(with: .minus) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand * thirdOperand)
		}
		// 1 + 2 * 3 - 4
		calculator.setOperand(forthOperand)
		// 1 + 2 * 3 - 4 / -> 3
		calculator.performOperation(with: .divide) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand * thirdOperand - forthOperand)
		}
		// 1 + 2 * 3 - 4 / 5
		calculator.setOperand(fifthOperand)
		// 1 + 2 * 3 - 4 / 5 * -> 6.2
		calculator.performOperation(with: .multiple) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand * thirdOperand - forthOperand / fifthOperand)
		}
		// 1 + 2 * 3 - 4 / 5 * 6
		calculator.setOperand(sixthOperand)
		// 1 + 2 * 3 - 4 / 5 * 6 -> 2.2
		calculator.performOperation(with: .equals) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand * thirdOperand - forthOperand / fifthOperand * sixthOperand)
		}
	}

	func testOnePlusTwoMultiplePercentOperation() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}

			XCTAssertEqual(accumulator, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 * -> 3
		calculator.performOperation(with: .multiple) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand)
		}
		// 1 + 2 * % -> 0.06
		calculator.performOperation(with: .percent) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, (firstOperand + secondOperand) / 100 * secondOperand)
		}
		// 1 + 2 * % = -> 1.12
		calculator.performOperation(with: .equals) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand * ((firstOperand + secondOperand) / 100 * secondOperand))
		}
	}

	func testOnePlusTwoMinusPercentOperation() {
		// 1
		calculator.setOperand(firstOperand)
		// 1 + -> 1
		calculator.performOperation(with: .plus) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}

			XCTAssertEqual(accumulator, firstOperand)
		}
		// 1 + 2
		calculator.setOperand(secondOperand)
		// 1 + 2 - -> 3
		calculator.performOperation(with: .minus) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand)
		}
		// 1 + 2 - % -> 0.06
		calculator.performOperation(with: .percent) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, (firstOperand + secondOperand) / 100 * secondOperand)
		}
		// 1 + 2 - % = -> 2.94
		calculator.performOperation(with: .equals) { result in
			guard case .success(let accumulator) = result else {
				XCTFail()
				return
			}
			XCTAssertEqual(accumulator, firstOperand + secondOperand - ((firstOperand + secondOperand) / 100 * secondOperand))
		}
	}
}
