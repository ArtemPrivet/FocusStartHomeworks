//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Artem Orlov on 12/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorViewController: UIViewController
{
	private let calculatorView = CalculatorView()

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	override func loadView() {
		self.view = calculatorView
	}

}
