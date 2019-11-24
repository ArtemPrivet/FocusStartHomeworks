//
//  FormatterExtensions.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 24/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

extension Formatter
{
	static let withSeparator: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.groupingSeparator = " "
		formatter.numberStyle = .decimal
		return formatter
	}()
}

extension Double
{
	var formattedWithSeparator: String {
		return Formatter.withSeparator.string(for: self) ?? ""
	}
}
