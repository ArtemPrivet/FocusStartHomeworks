//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Artem Orlov on 12/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit
import SnapKit

final class CalculatorViewController: UIViewController
{

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		self.view = CalcalatorView()
	}
}
