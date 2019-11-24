//
//  TypeOfButton.swift
//  Calculator
//
//  Created by Максим Шалашников on 21.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

enum ButtonOperationType: String
{
	case digit = "0123456789,"
	case operation = "-+=/*"
	case symbolic = "AC%+-"
}
