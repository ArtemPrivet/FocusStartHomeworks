//
//  Button.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 16.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class Button: UIButton
{
	var isTransform = true

	init() {
		super.init(frame: .zero)
		setup()
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 32)
		titleLabel?.textAlignment = .center
		backgroundColor = .darkGray
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		if isTransform {
		bounds.size.width = bounds.size.height
		}
		else {
			//offset to button title
			bounds = bounds.offsetBy(dx: bounds.size.width / 4, dy: 0)
		}
		layer.cornerRadius = bounds.size.height / 2
	}
}
