//
//  CalculatorInfixToPostfixTest.swift
//  CalculatorTests
//
//  Created by Arkadiy Grigoryanc on 24.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest
@testable import Calculator

final class CalculatorInfixToPostfixTest: XCTestCase
{
	private let plus = CalculatorEngine.Operator.plus.rawValue
	private let minus = CalculatorEngine.Operator.minus.rawValue
	private let divide = CalculatorEngine.Operator.divide.rawValue
	private let multiple = CalculatorEngine.Operator.multiple.rawValue

	private lazy var infixArray1 = ["1", plus, "2", multiple, "3"]
	private lazy var infixArray2 = ["1", minus, "2", plus, "3"]
	private lazy var infixArray3 = ["1", divide, "2", multiple, "3"]
	private lazy var infixArray4 = ["1", divide, "2", minus, "3"]
	private lazy var infixArray5 = ["1", plus, "2", multiple, "3", minus, "4"]
	private lazy var infixArray6 = ["1", plus, "2", multiple, "3", divide, "4"]
	private lazy var infixArray7 = ["1", plus, "2", minus, "3", divide, "4"]
	private lazy var infixArray8 = ["1", multiple, "2", multiple, "3", minus, "4"]
	private lazy var infixArray9 = ["1", multiple, "2", plus, "3", divide, "4"]
	private lazy var infixArray10 =
		[
			"1", multiple, "2", plus, "3", divide, "4",
			divide, "5", minus, "6", multiple, "7",
	]

	private lazy var postfixArray1 = ["1", "2", "3", multiple, plus]
	private lazy var postfixArray2 = ["1", "2", minus, "3", plus]
	private lazy var postfixArray3 = ["1", "2", divide, "3", multiple]
	private lazy var postfixArray4 = ["1", "2", divide, "3", minus]
	private lazy var postfixArray5 = ["1", "2", "3", multiple, plus, "4", minus]
	private lazy var postfixArray6 = ["1", "2", "3", multiple, "4", divide, plus]
	private lazy var postfixArray7 = ["1", "2", plus, "3", "4", divide, minus]
	private lazy var postfixArray8 = ["1", "2", multiple, "3", multiple, "4", minus]
	private lazy var postfixArray9 = ["1", "2", multiple, "3", "4", divide, plus]
	private lazy var postfixArray10 =
		[
			"1", "2", multiple, "3", "4", divide, "5",
			divide, plus, "6", "7", multiple, minus,
	]

	private lazy var infixArrays: [[CalculatorEngine.OperationStack]] = {
		let arrays =
			[
				infixArray1, infixArray2, infixArray3, infixArray4, infixArray5, infixArray6,
				infixArray7, infixArray8, infixArray9, infixArray10,
		]
		return arrays.reduce(into: []) { $0.append($1.compactMap { CalculatorEngine.OperationStack(string: $0) }) }
	}()

	private lazy var postfixQueues: [Queue<CalculatorEngine.OperationStack>] = {
		let arrays =
			[
				postfixArray1, postfixArray2, postfixArray3, postfixArray4, postfixArray5, postfixArray6,
				postfixArray7, postfixArray8, postfixArray9, postfixArray10,
		]
		return arrays.reduce(into: []) { result, array in
			let array = array.compactMap { CalculatorEngine.OperationStack(string: $0) }
			result.append(Queue<CalculatorEngine.OperationStack>(array))
		}
	}()

	func testConvertable() {
		infixArrays.enumerated().forEach { offset, operationStack in
			do {
				let convertedArray = try operationStack.convertToPostfix()
				XCTAssertEqual(convertedArray, postfixQueues[offset])
			}
			catch {
				// swiftlint:disable:next xctfail_message
				XCTFail()
			}
		}
	}
}
