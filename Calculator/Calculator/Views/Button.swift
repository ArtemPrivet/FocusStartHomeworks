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
	var isRounded = true

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
		if isRounded {
			bounds.size.width = bounds.size.height
		}
		else {
			//offset zero button title to left side
			titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.size.width / 2)
		}
		layer.cornerRadius = bounds.size.height / 2
	}
}
