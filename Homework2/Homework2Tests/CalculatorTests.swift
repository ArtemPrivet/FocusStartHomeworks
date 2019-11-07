//
//  TestProjectWithCITests.swift
//  TestProjectWithCITests
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

import XCTest
@testable import Homework2

// swiftlint:disable implicitly_unwrapped_optional
final class StringTests: XCTestCase
{
	private let string = "проверка ввода"

	func testReverseWords() {
		let reversedString = string.reversedWords()
		let expectedResult = "акреворп адовв"
		XCTAssertEqual(reversedString, expectedResult)
	}

	func testSubstring() {
		let substring = string.substring(from: 3, to: 8)
		let expectedResult = "верка "
		XCTAssertEqual(string.reversedWords(), expectedResult)
	}
}
