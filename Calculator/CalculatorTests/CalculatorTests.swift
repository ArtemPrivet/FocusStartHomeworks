//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Artem Orlov on 15/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import XCTest

final class CalculatorTests: XCTestCase
{
	let polishNotation = PolishNotation()

	func testAdd() {
		let items1: [Item] = [.number(1), .sign(.plus), .number(2)]
		let items2: [Item] = [.number(225), .sign(.plus), .number(123)]
		let items3: [Item] = [.number(225.5), .sign(.plus), .number(123.4)]
		let items4: [Item] = [.number(225.5), .sign(.plus), .number(123.4), .sign(.plus), .number(10)]

//		XCTAssert(polishNotation.makeCalculation(items1) == 3)
//		XCTAssert(polishNotation.makeCalculation(items2) == 348)
//		XCTAssert(polishNotation.makeCalculation(items3) == 348.9)
//		XCTAssert(polishNotation.makeCalculation(items4) == 358.9)
	}

	func testSubtract() {
		let items1: [Item] = [.number(1), .sign(.minus), .number(2)]
		let items2: [Item] = [.number(225), .sign(.minus), .number(123)]
		let items3: [Item] = [.number(225.6), .sign(.minus), .number(123.3)]
		let items4: [Item] = [.number(225.5), .sign(.minus), .number(123.4), .sign(.minus), .number(10)]

//		XCTAssert(polishNotation.makeCalculation(items1) == -1)
//		XCTAssert(polishNotation.makeCalculation(items2) == 102)
//		XCTAssert(polishNotation.makeCalculation(items3) == 102.3)
//		XCTAssert(polishNotation.makeCalculation(items4) == 92.1)
	}

	func testMultiply() {
		let items1: [Item] = [.number(1), .sign(.multiply), .number(2)]
		let items2: [Item] = [.number(15), .sign(.multiply), .number(4)]
		let items3: [Item] = [.number(1.5), .sign(.multiply), .number(10)]
		let items4: [Item] = [.number(1.5), .sign(.multiply), .number(10), .sign(.multiply), .number(5)]

//		XCTAssert(polishNotation.makeCalculation(items1) == 2)
//		XCTAssert(polishNotation.makeCalculation(items2) == 60)
//		XCTAssert(polishNotation.makeCalculation(items3) == 15)
//		XCTAssert(polishNotation.makeCalculation(items4) == 75)
	}

	func testDivide() {
		let items1: [Item] = [.number(1), .sign(.divide), .number(2)]
		let items2: [Item] = [.number(15), .sign(.divide), .number(5)]
		let items3: [Item] = [.number(15), .sign(.divide), .number(10)]
		let items4: [Item] = [.number(81), .sign(.divide), .number(3), .sign(.divide), .number(3)]

//		XCTAssert(polishNotation.makeCalculation(items1) == 0.5)
//		XCTAssert(polishNotation.makeCalculation(items2) == 3)
//		XCTAssert(polishNotation.makeCalculation(items3) == 1.5)
//		XCTAssert(polishNotation.makeCalculation(items4) == 9)
	}
}
