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
		 for elem in self {
			 mapped.append(transform(elem))
		 }
		 return mapped
	 }

	 func customReduce<T>(_ initialResult: T, _ nextPartialResult: (T, Element) -> (T)) -> T {
		 var initialResult = initialResult
		 for elem in self {
			 initialResult = nextPartialResult(initialResult, elem)
		 }
		 return initialResult
	 }

	 func customCompactMap<T>(_ transform: (Element) -> (T?)) -> [T] {
		 var mapped = [T]()
		 for elem in self {
			if let transformed = transform(elem) {
				mapped.append(transformed)
			}
		}
		return mapped
	 }
}
