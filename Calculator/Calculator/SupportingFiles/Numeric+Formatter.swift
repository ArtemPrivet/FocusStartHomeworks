//
//  Numeric+Formatter.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 23.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

extension Numeric
{
	var scientificFormatted: String {
		Formatter.scientific.string(for: self) ?? ""
	}

	var decimalFormatted: String {
		Formatter.decimal.string(for: self) ?? ""
	}
}
