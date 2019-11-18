//
//  ResultView.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 16.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit
import SnapKit

final class ResultView: UIView
{

	// MARK: Properties
	var text: String? {
		set {
			resultLabel.text = newValue
		}
		get {
			resultLabel.text
		}
	}

	// MARK: Private properties
	private let textColor: UIColor
	private lazy var resultLabel: UILabel = {
		let label = UILabel()
		label.text = "0"
		label.textAlignment = .right
		label.font = UIFont(name: "FiraSans-Light", size: 94)
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.5
		label.textColor = self.textColor
		return label
	}()

	// MARK: Initialization
	init(backgroundColor: UIColor, textColor: UIColor) {
		self.textColor = textColor
		super.init(frame: .zero)
		setup(backgroundColor: backgroundColor)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Private methods
	private func setup(backgroundColor: UIColor) {
		self.backgroundColor = backgroundColor
		addSubview(resultLabel)
		makeConstraints()
	}

	private func makeConstraints() {
		resultLabel.snp.makeConstraints { maker in
			maker.edges.equalToSuperview()
		}
	}
}
