//
//  CalculatorActionsProtocol.swift
//  Calculator
//
//  Created by Иван Медведев on 19/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

protocol CalculatorViewDelegate: AnyObject
{
	func clickedButton(_ text: String)
}
