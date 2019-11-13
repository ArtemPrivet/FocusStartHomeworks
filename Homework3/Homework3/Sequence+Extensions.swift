//
//  Calculator.swift
//  Homework3
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

extension Sequence
{
	func customMap <T>(customFunction: (Self.Element) -> T) -> [T] {
		var result = [T]()
		for element in self {
			result.append(customFunction(element))
		}
		return result
	}

	func customReduce() {
		// ...
	}

	func customCompactMap() {
		//...
	}
}
