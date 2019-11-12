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
		let expectedNumbers = numbers.reduce(0, sumOf)
		let expectedStrings = strings.reduce("", withSpaceBetwin)

		let actualNumbers = numbers.customReduce(0, sumOf)
		let actualStrings = strings.customReduce("", withSpaceBetwin)

		XCTAssertEqual(expectedNumbers, actualNumbers)
		XCTAssertEqual(expectedStrings, actualStrings)
	}

	func testCustomReduceUseInto() {
		let expectedNumbers = numbers.reduce(into: 0, addToResult)
		let expectedStrings = strings.reduce(into: "", concatenateToResult)

		let actualNumbers = numbers.customReduce(into: 0, addToResult)
		let actualStrings = strings.customReduce(into: "", concatenateToResult)

		XCTAssertEqual(expectedNumbers, actualNumbers)
		XCTAssertEqual(expectedStrings, actualStrings)
	}

	func testCustomCompactMap() {
		let expectedString = string.compactMap(asciiValue)
		let expectedStrings = strings.compactMap(int)

		let actualString = string.customCompactMap(asciiValue)
		let actualStrings = strings.customCompactMap(int)

		XCTAssertEqual(expectedString, actualString)
		XCTAssertEqual(expectedStrings, actualStrings)
	}
}

private extension SequenceTest
{
	private func square(of number: Int) -> Int {
		number * number
	}

	private func uppercase(_ char: Character) -> String {
		char.uppercased()
	}

	private func withExclamationMark(_ string: String) -> String {
		string + "!"
	}

	private func sumOf(_ number1: Int, andSquareOf number2: Int) -> Int {
		number1 + square(of: number2)
	}

	private func withSpaceBetwin(_ string1: String, and string2: String) -> String {
		string1 + " " + string2
	}

	private func asciiValue(of character: Character) -> UInt8? {
		character.asciiValue
	}

	private func int(of string: String) -> Int? {
		Int(string)
	}

	private func addToResult(_ result: inout Int, number: Int) {
		result += number
	}

	private func concatenateToResult(_ result: inout String, string: String) {
		result += " " + string
	}
}
