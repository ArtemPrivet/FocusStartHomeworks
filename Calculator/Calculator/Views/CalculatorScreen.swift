//
//  CalculatorScreen.swift
//  Calculator
//
//  Created by Igor Shelginskiy on 11/17/19.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation
import SnapKit

final class CalculatorScreen: UIView
{
	let resultLabel = Resultlabel()
	let buttonsView = StackButtons()

	init() {
		super.init(frame: .zero)
		backgroundColor = .black
		addSubview(buttonsView)
		addSubview(resultLabel)
		makeConstraint()
		translatesAutoresizingMaskIntoConstraints = false
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func makeConstraint() {
		buttonsView.snp.makeConstraints { maker in
			maker.bottom.equalToSuperview().offset(-12)
			maker.leading.equalToSuperview().offset(8)
			maker.trailing.equalToSuperview().offset(-8)
			maker.height.equalTo(buttonsView.snp.width).multipliedBy(1.25)
		}
		resultLabel.snp.makeConstraints { maker in
			maker.leading.equalToSuperview().offset(16)
			maker.trailing.equalToSuperview().offset(-16)
			maker.height.equalTo(113)
			maker.bottom.equalTo(buttonsView.snp.top).offset(-8)
		}
	}
}
