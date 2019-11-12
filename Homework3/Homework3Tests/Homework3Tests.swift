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

		let actualString = string.customMap(using: uppercase)
		let actualNumbers = numbers.customMap(using: square)
		let actualStrings = strings.customMap(using: withExclamationMark)

		XCTAssertEqual(expectedString, actualString)
		XCTAssertEqual(expectedNumbers, actualNumbers)
		XCTAssertEqual(expectedStrings, actualStrings)
	}

	func testCustomReduce() {
		let expectedNumbers = numbers.reduce(0, sumOfSquares)
		let expectedStrings = strings.reduce("", concatBySpaces)

		let actualNumbers = numbers.customReduce(0, using: sumOfSquares)
		let actualStrings = strings.customReduce("", using: concatBySpaces)

		XCTAssertEqual(expectedNumbers, actualNumbers)
		XCTAssertEqual(expectedStrings, actualStrings)
	}

	func testCustomCompactMap() {
		let expectedString = string.compactMap(toAscii)
		let expectedStrings = strings.compactMap(toInt)

		let actualString = string.customCompactMap(using: toAscii)
		let actualStrings = strings.customCompactMap(using: toInt)

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

	private func sumOfSquares(_ accumulator: Int, _ element: Int) -> Int {
		return accumulator + element * element
	}

	private func concatBySpaces(_ accumulator: String, _ element: String) -> String {
		return accumulator + " " + element
	}

	private func toAscii(_ element: Character) -> UInt8? {
		return element.asciiValue
	}

	private func toInt(_ element: String) -> Int? {
		return Int(element)
	}
}
