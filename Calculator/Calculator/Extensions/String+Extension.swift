//
//  String+Extension.swift
//  Calculator
//
//  Created by Kirill Fedorov on 24.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

extension String
{

	func replacedDot() -> String {
		return self.replacingOccurrences(of: ".", with: ",")
	}
}
