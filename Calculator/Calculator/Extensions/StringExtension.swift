//
//  StringExtension.swift
//  Calculator
//
//  Created by Максим Шалашников on 22.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation
extension String
{
	func count(character: Character) -> Int {
		return self.reduce(0){ counter, symbol  in
			if symbol == character {
				return counter + 1
			}
			return counter
		}
	}
	func index(from: Int) -> Index {
		return self.index(startIndex, offsetBy: from)
	}
	func substring(from: Int) -> String {
		let fromIndex = index(from: from)
		return String(self[fromIndex...])
	}
	func substring(to: Int) -> String {
		let toIndex = index(from: to)
		return String(self[..<toIndex])
	}
	func substring(with range: Range<Int>) -> String {
		let startIndex = index(from: range.lowerBound)
		let endIndex = index(from: range.upperBound)
		return String(self[startIndex..<endIndex])
	}
}
