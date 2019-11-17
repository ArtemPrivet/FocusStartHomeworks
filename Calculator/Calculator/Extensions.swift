//
//  Extensions.swift
//  Calculator
//
//  Created by Kirill Fedorov on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection
{
	mutating func insert(separator: Self, every num: Int) {
		for index in indices.reversed() where index != startIndex &&
			distance(from: startIndex, to: index) % num == 0 {
				insert(contentsOf: separator, at: index)
		}
	}

	func inserting(separator: Self, every num: Int) -> Self {
		var string = self
		string.insert(separator: separator, every: num)
		return string
	}
}
