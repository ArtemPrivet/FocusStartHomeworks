//
//  RowButtonsStackView.swift
//  Calculator
//
//  Created by Kirill Fedorov on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class RowButtonsStackView: UIStackView
{

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupButton()
	}

	@available (*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupButton() {

		axis = .horizontal
		distribution = .fillEqually
		spacing = 14
	}
}
