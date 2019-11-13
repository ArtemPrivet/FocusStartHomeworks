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

		let actualString = string.customMap { $0.uppercased() }
		let actualNumbers = numbers.customMap { $0 * $0 }
		let actualStrings = strings.customMap { $0 + "!" }

		XCTAssertEqual(expectedString, actualString)
		XCTAssertEqual(expectedNumbers, actualNumbers)
		XCTAssertEqual(expectedStrings, actualStrings)
	}

	func testCustomReduce() {
		let expectedNumbers = numbers.reduce(0, sumOfNumberAndSquare)
		let expectedStrings = strings.reduce("", withSpacing)

		let actualNumbers = numbers.customReduce(0) { $0 + $1 * $1 }
		let actualStrings = strings.customReduce("") { $0 + " " + $1 }

		XCTAssertEqual(expectedNumbers, actualNumbers)
		XCTAssertEqual(expectedStrings, actualStrings)
	}

	func testCustomCompactMap() {
		let expectedString = string.compactMap(convertToAsciiValue)
		let expectedStrings = strings.compactMap(convertToInt)

		let actualString = string.customCompactMap { $0.asciiValue }
		let actualStrings = strings.customCompactMap { Int($0) }

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

	private func sumOfNumberAndSquare(_ number1: Int, _ number2: Int) -> Int {
		return number1 + number2 * number2
	}

	private func withSpacing(_ string1: String, _ string2: String) -> String {
		return string1 + " " + string2
	}

	private func convertToAsciiValue(_ char: Character) -> UInt8? {
		return char.asciiValue
	}

	private func convertToInt(_ string: String) -> Int? {
		return Int(string)
	}
}
