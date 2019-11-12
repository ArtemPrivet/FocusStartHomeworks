//
//  Calculator.swift
//  Homework3
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

extension Sequence
{
	func customMap<T>(_ transform: (Element) -> (T)) -> [T] {
		 var mapped = [T]()
		 for element in self {
			 mapped.append(transform(element))
		 }
		 return mapped
	 }

	 func customReduce<T>(_ initialResult: T, _ nextPartialResult: (T, Element) -> (T)) -> T {
		 var initialResult = initialResult
		 for element in self {
			 initialResult = nextPartialResult(initialResult, element)
		 }
		 return initialResult
	 }

	 func customCompactMap<T>(_ transform: (Element) -> (T?)) -> [T] {
		 var mapped = [T]()
		 for element in self {
			if let transformed = transform(element) {
				mapped.append(transformed)
			}
		}
		return mapped
	 }
}
