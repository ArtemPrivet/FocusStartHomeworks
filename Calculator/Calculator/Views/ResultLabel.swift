//
//  ResultLabel.swift
//  Calculator
//
//  Created by Igor Shelginskiy on 11/17/19.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class Resultlabel: UILabel
{

	init() {
		super.init(frame: .zero)
		backgroundColor = .black
		textColor = .white
		adjustsFontSizeToFitWidth = true
		textAlignment = .right
		font = UIFont(name: "FiraSans-Light", size: 100)
		adjustsFontSizeToFitWidth = true
		text = "0"
		translatesAutoresizingMaskIntoConstraints = false
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
