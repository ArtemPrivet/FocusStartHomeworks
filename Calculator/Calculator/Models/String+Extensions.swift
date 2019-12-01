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

		guard let number = Double(self.replacingOccurrences(of: ",", with: ".")) else { return result }

		let formatter = NumberFormatter()
		formatter.usesGroupingSeparator = false
		if self.count <= 9 || number.exponent == 0 {
			formatter.maximumSignificantDigits = 9
			formatter.numberStyle = .decimal
		}
		else {
			formatter.numberStyle = .scientific
			formatter.positiveFormat = "0.###E0"
			formatter.exponentSymbol = "e"
		}

		result = formatter.string(from: NSNumber(value: number))?.replacingOccurrences(of: ".", with: ",") ?? "0"
		return result
	}
}
