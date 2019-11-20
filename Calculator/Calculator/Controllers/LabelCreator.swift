//
//  LabelCreator.swift
//  Calculator
//
//  Created by Stanislav on 19/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

struct LabelCreator
{
	func setUpLabelWithGestureRecognizer(label: UILabel, recognizer: UIGestureRecognizer) {
		label.text = "0"
		label.font = UIFont(name: "FiraSans-Light", size: 94)
		label.textColor = UIColor(hex: "#FFFFFF")
		label.textAlignment = .right
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.2
		label.isUserInteractionEnabled = true
		label.addGestureRecognizer(recognizer)
	}
	func setUpLabelConstraints(label: UILabel, bottomView: UIStackView, safeAreaMargins: UILayoutGuide) {
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: safeAreaMargins.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: safeAreaMargins.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
		])
	}
}
