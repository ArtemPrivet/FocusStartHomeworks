//
//  Homework3Tests.swift
//  Homework3Tests
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

import XCTest
@testable import Homework3

final class SequenceTest: XCTestCase
{
	private let string = "проверка ввода"
	private let numbers = [1, 7, 8, 3, 6, 4, 5, 0, 1]
	private let strings = ["1", "2", "3", "b"]

	func testCustomMap() {
		let expectedString = string.map(uppercase)
		let expectedNumbers = numbers.map(square)
		let expectedStrings = strings.map(withExclamationMark)

		let actualString = string.customMap(uppercase)
		let actualNumbers = numbers.customMap(square)
		let actualStrings = strings.customMap(withExclamationMark)

		XCTAssertEqual(expectedString, actualString)
		XCTAssertEqual(expectedNumbers, actualNumbers)
		XCTAssertEqual(expectedStrings, actualStrings)
	}

	func testCustomReduce() {
		let expectedNumbers = numbers.reduce(0, sumSquare)
		let expectedStrings = strings.reduce("", additionString)

		let actualNumbers = numbers.customReduce(0, sumSquare)
		let actualStrings = strings.customReduce("", additionString)

		XCTAssertEqual(expectedNumbers, actualNumbers)
		XCTAssertEqual(expectedStrings, actualStrings)
	}

	func testCustomCompactMap() {
		let expectedString = string.compactMap(convertToasciiValue)
		let expectedStrings = strings.compactMap(convertToInt)

		let actualString = string.customCompactMap(convertToasciiValue)
		let actualStrings = strings.customCompactMap(convertToInt)

		XCTAssertEqual(expectedString, actualString)
		XCTAssertEqual(expectedStrings, actualStrings)
	}
}

private extension SequenceTest
{
	private func square(of number: Int) -> Int {
		return number * number
	}

	private func uppercase(_ char: Character) -> String {
		return char.uppercased()
	}

	private func withExclamationMark(_ string: String) -> String {
		return string + "!"
	}

	private func sumSquare(_ value: Int, _ squareElement: Int) -> Int {
		return value + (squareElement * squareElement)
	}

	private func additionString(_ lhString: String, _ rhString: String) -> String {
		return lhString + " " + rhString
	}

	private func convertToasciiValue(_ char: Character) -> UInt8? {
		return char.asciiValue
	}

	private func convertToInt(_ value: String) -> Int? {
		return Int(value)
	}
}
