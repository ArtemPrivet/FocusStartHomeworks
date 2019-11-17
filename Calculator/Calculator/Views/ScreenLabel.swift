//
//  ScreenLabel.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 16.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class ScreenLabel: UILabel
{
	init() {
		super.init(frame: .zero)
		setup()
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		translatesAutoresizingMaskIntoConstraints = false
		font = UIFont(name: "FiraSans-Light", size: 94)
		minimumScaleFactor = 0.5
		textColor = .white
		textAlignment = .right
		text = "0"
	}
}
