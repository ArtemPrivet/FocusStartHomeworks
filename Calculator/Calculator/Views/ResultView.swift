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

	var text: String? {
		set {
			resultLabel.text = newValue
		}
		get {
			resultLabel.text
		}
	}

	private var resultLabel: UILabel = {
		let label = UILabel()
		label.text = "0"//"000 000 000"
		label.textAlignment = .right
		label.font = UIFont(name: "FiraSans-Light", size: 94)
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.5
		return label
	}()

	init() {
		super.init(frame: .zero)
		setup()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		backgroundColor = .yellow
		addSubview(resultLabel)
		makeConstraints()
	}

	private func makeConstraints() {
		resultLabel.snp.makeConstraints { maker in
			maker.edges.equalToSuperview()
		}
	}
}
