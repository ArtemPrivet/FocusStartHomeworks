//
//  CalcalatorView.swift
//  Calculator
//
//  Created by Kirill Fedorov on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalcalatorView: UIView
{
	var displayLabel = Displaylabel()
	var buttons = [CalculatorButton]()
	var buttonsCount = 18
	private var rows = [RowButtonsStackView]()

	private var buttonSymbols = [
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
		",", "=", "+", "-", "×", "÷", "%", "⁺∕₋", "AC",
	]

	private var firstRowButtons = RowButtonsStackView()
	private var secondRowButtons = RowButtonsStackView()
	private var thirdRowButtons = RowButtonsStackView()
	private var fourthRowButtons = RowButtonsStackView()
	private var fifthRowButtons = RowButtonsStackView()

	private var buttonsStackView = ButtonsStackView()

	init() {
		super.init(frame: .zero)
		backgroundColor = .white
		addSubview(displayLabel)
		crateButtons()
		setButtonsColor(buttons: buttons)
		setRowsButtons()
		makeConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func crateButtons() {
		for index in 0...buttonsCount {
			let button = CalculatorButton()
			button.tag = index
			button.setTitle(buttonSymbols[index], for: .normal)
			switch index {
			case 0, 10, 11:
				fifthRowButtons.addArrangedSubview(button)
			case 1...3, 12:
				fourthRowButtons.addArrangedSubview(button)
			case 4...6, 13:
				thirdRowButtons.addArrangedSubview(button)
			case 7...9, 14:
				secondRowButtons.addArrangedSubview(button)
			case 15...18:
				firstRowButtons.insertArrangedSubview(button, at: 0)
			default: break
			}
			buttons.append(button)
		}
	}

	private func setButtonsColor(buttons: [CalculatorButton]) {
		buttons.forEach { button in
			switch button.tag {
			case 0...10:
				button.backgroundColor = Colors.colorDarkGray
				button.setTitleColor(Colors.colorWhite, for: .normal)
				button.buttonColorType = .darkGray
			case 11...15:
				button.backgroundColor = Colors.colorOrange
				button.setTitleColor(Colors.colorWhite, for: .normal)
				button.setTitleColor(Colors.colorOrange, for: .highlighted)
				button.buttonColorType = .orange
			case 16...18:
				button.backgroundColor = Colors.colorGray
				button.setTitleColor(Colors.colorBlack, for: .normal)
				button.buttonColorType = .lightGray
			default: break
			}
		}
	}

	private func setRowsButtons() {
		fifthRowButtons.alignment = .fill
		fifthRowButtons.distribution = .fill
		buttonsStackView = ButtonsStackView(arrangedSubviews: [
			firstRowButtons,
			secondRowButtons,
			thirdRowButtons,
			fourthRowButtons,
			fifthRowButtons,
			])
	}

	private func makeConstraints() {
		for button in buttons where button.tag != 0 {
			button.snp.makeConstraints { make in
				make.width.equalTo(button.snp.height).multipliedBy(1)
			}
		}

		fifthRowButtons.snp.makeConstraints { make in
			var equalBut = CalculatorButton()
			for view in buttons where view.tag == 0 {
				equalBut = view
			}
			make.width.equalTo(equalBut.snp.width).multipliedBy(2).offset(14)
		}

		buttonsStackView.snp.makeConstraints { [weak self] make in
			guard let self = self else { return }
			addSubview(buttonsStackView)
			make.leading.equalTo(self).offset(16)
			make.trailing.equalTo(self).offset(-17)
			make.bottomMargin.equalTo(self).offset(-16)
		}

		displayLabel.snp.makeConstraints { [weak self] make in
			guard let self = self else { return }
			make.leading.equalTo(self).offset(15)
			make.trailing.equalTo(self).offset(-17)
			make.bottom.equalTo(buttonsStackView.snp.top).offset(-8)
			make.height.equalTo(113)
		}
	}
}
