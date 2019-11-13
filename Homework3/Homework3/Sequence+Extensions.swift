//
//  Calculator.swift
//  Homework3
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

extension Sequence
{
	func customMap <T>(_ customFunction: (Self.Element) -> T) -> [T]? {
		var result = [T]()
		for element in self {
			result.append(customFunction(element))
		}
		return result
	}
	func customReduce <T>(_ initialValue: T, _ customFunction: (T, Self.Element) -> T) -> T {
		var result = initialValue
		for singleElement in self {
			result = customFunction(result, singleElement)
		}
		return result
	}
	func customCompactMap <T>(customFunction: (Self.Element) -> T?) -> [T] {
		var result = [T]()
		for element in self where customFunction(element) != nil {
			if let unwrapped = customFunction(element) {
				result.append(unwrapped)
			}
		}
		return result
	}
}
