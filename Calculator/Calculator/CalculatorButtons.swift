//
//  ButtonView.swift
//  Calculator
//
//  Created by Kirill Fedorov on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorButtons: UIButton
{
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupButton()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	func setupButton() {
		backgroundColor	= Colors.colorGray
		titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 30)
		setTitleColor(.black, for: .normal)
	}
}
