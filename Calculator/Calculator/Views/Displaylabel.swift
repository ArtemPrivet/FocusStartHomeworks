//
//  Displaylabel.swift
//  Calculator
//
//  Created by Kirill Fedorov on 22.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class Displaylabel: UILabel
{
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupDisplayLabel()
	}

	@available (*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupDisplayLabel() {
		self.font = UIFont(name: "FiraSans-Light", size: 94)
		self.textColor = Colors.colorWhite
		self.textAlignment = .right
		self.text = "0"
		self.adjustsFontSizeToFitWidth = true
	}
}
