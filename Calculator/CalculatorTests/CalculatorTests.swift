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
	var calculatorEngine = CalculatorEngine()

	func testActions() {
		let items1: [Item] = [.number(1), .sign(.plus), .number(2)]
		let items2: [Item] = [.number(225), .sign(.plus), .number(123)]

		guard let result1 = polishNotation.makeCalculationToDouble(items1) else { return }
		XCTAssertEqual(result1, 3)

		guard let result2 = polishNotation.makeCalculationToDouble(items2) else { return }
		XCTAssertEqual(result2, 348)

		let items3: [Item] = [.number(1), .sign(.minus), .number(2)]
		let items4: [Item] = [.number(225), .sign(.minus), .number(123)]

		guard let result3 = polishNotation.makeCalculationToDouble(items3) else { return }
		XCTAssertEqual(result3, -1)

		guard let result4 = polishNotation.makeCalculationToDouble(items4) else { return }
		XCTAssertEqual(result4, 102)

		let items5: [Item] = [.number(1), .sign(.multiply), .number(2)]
		let items6: [Item] = [.number(15), .sign(.multiply), .number(4)]

		guard let result5 = polishNotation.makeCalculationToDouble(items5) else { return }
		XCTAssertEqual(result5, 2)

		guard let result6 = polishNotation.makeCalculationToDouble(items6) else { return }
		XCTAssertEqual(result6, 60)

		let items7: [Item] = [.number(1), .sign(.divide), .number(2)]
		let items8: [Item] = [.number(15), .sign(.divide), .number(5)]

		guard let result7 = polishNotation.makeCalculationToDouble(items7) else { return }
		XCTAssertEqual(result7, 0.5)

		guard let result8 = polishNotation.makeCalculationToDouble(items8) else { return }
		XCTAssertEqual(result8, 3)
	}

	func testPriority() {
		let items1: [Item] = [.number(1), .sign(.divide), .number(2), .sign(.plus), .number(5)]
		let items2: [Item] = [.number(15), .sign(.multiply), .number(5), .sign(.minus), .number(3)]
		let items3: [Item] = [.number(1), .sign(.plus), .number(2), .sign(.divide), .number(4)]
		let items4: [Item] = [.number(15), .sign(.minus), .number(5), .sign(.multiply), .number(3)]

		guard let result1 = polishNotation.makeCalculationToDouble(items1) else { return }
		XCTAssertEqual(result1, 5.5)

		guard let result2 = polishNotation.makeCalculationToDouble(items2) else { return }
		XCTAssertEqual(result2, 72)

		guard let result3 = polishNotation.makeCalculationToDouble(items3) else { return }
		XCTAssertEqual(result3, 1.5)

		guard let result4 = polishNotation.makeCalculationToDouble(items4) else { return }
		XCTAssertEqual(result4, 0)
	}

	func testPercent() {
		_ = calculatorEngine.addAction(input: "200")
		guard let resultPercent = calculatorEngine.percent(input: "10") else { return }
		guard let result = calculatorEngine.resultAction(input: resultPercent) else { return }
		print(resultPercent)
		print(result)
		XCTAssertEqual(resultPercent, "20")
		XCTAssertEqual(result, "220")
	}
}
