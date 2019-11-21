//
//  String+Extensions.swift
//  Calculator
//
//  Created by Иван Медведев on 20/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

extension String
{
	func format() -> String {
		var result = ""
		let containMinus = (self.first == "-")
		let containComma = self.contains(",")

		if containComma && containMinus {
			result = String(self.prefix(11))
			return result
		}
		else if containComma == false && containMinus {
			result = String(self.prefix(10))
			return result
		}
		else if containComma && containMinus == false {
			result = String(self.prefix(10))
			return result
		}
		else {
			result = String(self.prefix(9))
			return result
		}
	}
}
