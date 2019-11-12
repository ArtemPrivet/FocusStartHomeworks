//
//  Homework2Tests.swift
//  Homework2Tests
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

import XCTest
@testable import Homework3

final class StringTests: XCTestCase
{
	private let string = "проверка ввода"
	private let correctPhoneNumbers = [
		"+79111234567",
		"89990103200",
		"7(912)1236311",
		"+7 919 737 31 11",
		"+7 (912) 123-45-67",
	]
	private let wrongPhoneNumbers = [
		"123",
		"78121231212",
		"9991233311",
		"+7(981)123456",
		"7911123f4567",
	]

	func testReverseWords() {
		let reversedString = string.reversedWords()
		let expectedResult = "акреворп адовв"
		XCTAssertEqual(reversedString, expectedResult)
	}

	func testPhoneNumbers() {
		self.correctPhoneNumbers.forEach {
			let isValid = $0.validate()
			XCTAssertEqual(isValid, true)
		}
	}

	func testWrongPhoneNumbers() {
		self.wrongPhoneNumbers.forEach {
			let isValid = $0.validate()
			XCTAssertEqual(isValid, false)
		}
	}
}
