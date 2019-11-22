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
	let converterRpn = ConverterRPN()

	func test() {
		let test1 = ["2", "+", "2", "*", "2"]
		let test2 = ["15", "*", "2", "/", "10"]
		let test3 = ["150", "-", "2.5", "*", "-2"]
		let test4 = ["30", "+", "50", "*", "2", "/", "5"]
		let test5 = ["-7", "*", "-2", "*", "5", "/", "2.5"]
		let test6 = ["200", "/", "0.5", "*", "60", "/", "50", "/", "15", "-", "15", "/", "4"]

		XCTAssert(converterRpn.evaluateRpn(elements: test1) == 6)
		XCTAssert(converterRpn.evaluateRpn(elements: test2) == 3)
		XCTAssert(converterRpn.evaluateRpn(elements: test3) == 155)
		XCTAssert(converterRpn.evaluateRpn(elements: test4) == 50)
		XCTAssert(converterRpn.evaluateRpn(elements: test5) == 28)
		XCTAssert(converterRpn.evaluateRpn(elements: test6) == 28.25)
	}
}
