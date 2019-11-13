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
		let expectedNumbers = numbers.reduce(0, sumOfSquares)
		let expectedStrings = strings.reduce(" ", addSpaceBetween)

		let actualNumbers = numbers.customReduce(0, sumOfSquares)
		let actualStrings = strings.customReduce(" ", addSpaceBetween)

		XCTAssertEqual(expectedNumbers, actualNumbers)
		XCTAssertEqual(expectedStrings, actualStrings)
	}

	func testCustomCompactMap() {
		let expectedString = string.compactMap(getAscii)
		let expectedStrings = strings.compactMap(convertStringToInt)

		let actualString = string.customCompactMap(getAscii)
		let actualStrings = strings.customCompactMap(convertStringToInt)

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

	private func addSpaceBetween(_ firstString: String, _ secondString: String) -> String {
		return firstString + " " + secondString
	}

	private func sumOfSquares(_ sum: Int, _ number: Int) -> Int {
		return sum + (number * number)
	}

	private func convertStringToInt(_ string: String) -> Int? {
		return Int(string)
	}

	private func getAscii(_ char: Character) -> UInt8? {
		return char.asciiValue
	}
}
