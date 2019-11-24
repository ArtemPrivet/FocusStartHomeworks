//
//  CalculatorView.swift
//  Calculator
//
//  Created by Максим Шалашников on 21.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit
import SnapKit

final class CalculatorView: UIView
{
	private let mainStackView = UIStackView()
	private var horzontalStackViews = [UIStackView]()
	let resultLabel = UILabel()
	private let buttonTitles = [
		"AC", "+-", "%", "/", "7", "8", "9", "*", "4", "5", "6", "-", "1", "2", "3", "+", "0", ",", "=",
	]
	var buttons: [CalculatorButton] = []

	init() {
		super.init(frame: .zero)
		setupStackViews()
		setupButtons()
		setupLabel()
	}
	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		roundButtons()
	}
	// MARK: - Configuration methods
	private func setupLabel() {
		resultLabel.text = "0"
		resultLabel.adjustsFontSizeToFitWidth = true
		resultLabel.textAlignment = .right
		resultLabel.font = UIFont(name: "FiraSans-Light", size: 94)
		resultLabel.textColor = .white
		resultLabel.isUserInteractionEnabled = true
		addSubview(resultLabel)
		resultLabel.isUserInteractionEnabled = true
		makeLabelConstraint()
	}
	private func makeLabelConstraint() {
		resultLabel.snp.makeConstraints { maker in
			maker.bottom.equalTo(mainStackView.snp.top).offset(-8)
			maker.leading.equalTo(self).offset(15)
			maker.trailing.equalTo(self).offset(-17)
		}
	}
	private func setupStackViews() {
		addSubview(mainStackView)
		addAndConfigureChildStackViews()
		configureMainStackView()
		addSubview(mainStackView)
		makeMainStackViewConstraints()
	}
	private func setupButtons() {
		buttonTitles.forEach{ buttons.append(createButton(withTitle: $0)) }
		for index in 0..<buttons.count {
			switch index {
			case 0..<4:
				horzontalStackViews[0].addArrangedSubview(buttons[index])
			case 4..<8:
				horzontalStackViews[1].addArrangedSubview(buttons[index])
			case 8..<12:
				horzontalStackViews[2].addArrangedSubview(buttons[index])
			case 12..<16:
				horzontalStackViews[3].addArrangedSubview(buttons[index])
			case 16..<19:
				horzontalStackViews[4].addArrangedSubview(buttons[index])
			default:
				break
			}
		}
		makeButtonsConstraints()
	}
	private func roundButtons() {
		buttons.forEach{ button in
			//button.layoutIfNeeded()
			button.layer.cornerRadius = button.bounds.height / 2
		}
	}
	private func makeButtonsConstraints() {
		buttons[0].snp.makeConstraints { maker in
			maker.trailing.equalTo(buttons[1].snp.leading).offset(-14)
		}
		buttons[1].snp.makeConstraints { maker in
			maker.trailing.equalTo(buttons[2].snp.leading).offset(-14)
		}
		buttons[2].snp.makeConstraints { maker in
			maker.trailing.equalTo(buttons[3].snp.leading).offset(-14)
		}

		for (index, button) in buttons.enumerated() {
			if index == 16, let firstButton = buttons.first {
				button.snp.makeConstraints { maker in
					maker.height.equalTo(firstButton.snp.width)
					maker.width.equalTo(firstButton.snp.width).multipliedBy(2).offset(14)
				}
			}
			else if let firstButton = buttons.first {
				button.snp.makeConstraints { maker in
					maker.width.equalTo(firstButton.snp.width)
					maker.height.equalTo(firstButton.snp.height)
				}
			}
		}
	}
	private func createButton(withTitle title: String) -> CalculatorButton {
		return CalculatorButton(of: getButtonType(buttonTitle: title), with: title)
	}
	private func getButtonType(buttonTitle: String) -> ButtonOperationType {
		if "0123456789,".contains(buttonTitle) {
			return ButtonOperationType.digit
		}
		else if "-+=/*".contains(buttonTitle) {
			return ButtonOperationType.operation
		}
		else {
			return ButtonOperationType.symbolic
		}
	}
	private func makeMainStackViewConstraints() {
		mainStackView.snp.makeConstraints { maker in
			maker.bottom.equalTo(layoutMarginsGuide.snp.bottom).offset(-16)
			maker.leading.equalTo(self.snp.leading).offset(16)
			maker.trailing.equalTo(self.snp.trailing).offset(-16)
		}
	}
	private func configureMainStackView() {
		mainStackView.axis = .vertical
		mainStackView.alignment = .fill
		mainStackView.distribution = .equalSpacing
		mainStackView.spacing = 14
	}
	private func addAndConfigureChildStackViews() {
		for _ in 0..<5 {
			horzontalStackViews.append(UIStackView())
		}
		horzontalStackViews.forEach { stackView in
			stackView.axis = .horizontal
			stackView.alignment = .fill
			stackView.distribution = .equalSpacing
			stackView.spacing = 14
		}
		horzontalStackViews.forEach{ mainStackView.addArrangedSubview($0) }
	}
}
