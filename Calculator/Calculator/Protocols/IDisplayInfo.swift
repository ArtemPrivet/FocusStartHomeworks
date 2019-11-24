//
//  IDisplayInfo.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 23/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

protocol IDisplayInfo: AnyObject
{
	func displayingNow(nowText: String?)
}
