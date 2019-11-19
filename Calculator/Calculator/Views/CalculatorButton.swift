//
//  CalculatorButton.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 17/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorButton: UIView
{
	private let button = UIButton()

	init() {
		super.init(frame: .zero)
		button.backgroundColor = .purple
		addSubview(button)
		translatesAutoresizingMaskIntoConstraints = false
	}
	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
//		self.layer.cornerRadius = self.bounds.height / 2
	}

	func setText(_ text: String) {
		button.setTitle(text, for: .normal)
		button.tintColor = .white
	}
}
