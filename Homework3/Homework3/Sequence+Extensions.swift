//
//  Calculator.swift
//  Homework3
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

extension Sequence
{
	func customMap <T>(customFunction: (Self.Element) -> T) -> [T]? {
		var result = [T]()
		for element in self {
			result.append(customFunction(element))
		}
		return result
	}

//	func customReduce<T: Equatable>(_ startingPoint: Self.Element, _ customFunction: (T, T) throws -> T) rethrows -> T {
//		var result: T
//		var first: Element? = nil
//
//		for element in self.drop(while: { element in
//			if element != startingPoint {
//
//			} == nil {
//				first = element
//				return true
//			} else {
//				return false
//			}
//		}){
//			if element != startingPoint {
//result = customFunction(element)
//	}
//		<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Self.Element) throws -> Result) rethrows -> Result

			func customCompactMap<T>(customFunction: (Self.Element) -> T?) -> [T] {
				var result = [T]()
				for element in self where customFunction(element) != nil {
					if let unwrapped = customFunction(element) {
						result.append(unwrapped)
					}
				}
				return result
			}
}
