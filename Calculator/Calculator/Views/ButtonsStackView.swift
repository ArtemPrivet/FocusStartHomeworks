//
//  ButtonsStackView.swift
//  Calculator
//
//  Created by Kirill Fedorov on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class ButtonsStackView: UIStackView
{
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupButtonStack()
	}

	@available (*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupButtonStack() {
		axis = .vertical
		distribution = .fillEqually
		spacing = 15
	}
}
