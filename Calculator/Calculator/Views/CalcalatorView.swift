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
	var resultLabel = UILabel(frame: .zero)
	var buttons = [CalculatorButtons]()
	var rows = [RowButtonsStackView]()

	var firstRowButtons = RowButtonsStackView(frame: .zero)
	var secondRowButtons = RowButtonsStackView(frame: .zero)
	var thirdRowButtons = RowButtonsStackView(frame: .zero)
	var fourthRowButtons = RowButtonsStackView(frame: .zero)
	var fifthRowButtons = RowButtonsStackView(frame: .zero)

	var buttonsStackView = ButtonsStackView(frame: .zero)

	init() {
		super.init(frame: .zero)
		backgroundColor = .white
			addSubview(resultLabel)
		setupResultLabel()
		createNumbersButtons()
		createOtherButtons()
		setRowsButtons()
		setButtonsColor()
		makeConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupResultLabel() {
		resultLabel.font = UIFont(name: "FiraSans-Light", size: 94)
		resultLabel.textColor = Colors.colorWhite
		resultLabel.textAlignment = .right
		resultLabel.text = "0"
		resultLabel.adjustsFontSizeToFitWidth = true
	}

	//Создаем кнопки с цифрами
	func createNumbersButtons() {
		for index in (0...9).reversed() {
			let button = CalculatorButtons(frame: .zero)
			button.tag = index
			button.setTitle(String(button.tag), for: .normal)
			switch index {
			case 0:
				fifthRowButtons.insertArrangedSubview(button, at: 0)
			case 1...3:
				fourthRowButtons.insertArrangedSubview(button, at: 0)
			case 4...6:
				thirdRowButtons.insertArrangedSubview(button, at: 0)
			case 7...9:
				secondRowButtons.insertArrangedSubview(button, at: 0)
			default: break
			}
			buttons.append(button)
		}
	}

	//Создаем остальные кнопки
	func createOtherButtons() {
		for index in (10...18).reversed() {
			let button = CalculatorButtons(frame: .zero)
			button.tag = index
			buttons.append(button)
			switch index {
			case 10...11:
				fifthRowButtons.insertArrangedSubview(button, at: 1)
			case 12:
				fourthRowButtons.addArrangedSubview(button)
			case 13:
				thirdRowButtons.addArrangedSubview(button)
			case 14:
				secondRowButtons.addArrangedSubview(button)
			default:
				firstRowButtons.addArrangedSubview(button)
			}
		}
	}

	//Создаем остальные кнопки
	private func setOperationButtonsTitle(_ button: CalculatorButtons) {
		switch button.tag {
		case 10:
			button.setTitle(",", for: .normal)
		case 11:
			button.setTitle("=", for: .normal)
		case 12:
			button.setTitle("+", for: .normal)
		case 13:
			button.setTitle("-", for: .normal)
		case 14:
			button.setTitle("×", for: .normal)
		case 15:
			button.setTitle("\u{00f7}", for: .normal)
		case 16:
			button.setTitle("%", for: .normal)
		case 17:
			button.setTitle("⁺∕₋", for: .normal)
		case 18:
			button.setTitle("AC", for: .normal)
		default: break
		}
	}

	func setButtonsColor() {
		for button in buttons {
			switch button.tag {
			case 0...10:
				button.backgroundColor = Colors.colorDarkGray
				button.setTitleColor(Colors.colorWhite, for: .normal)
				setOperationButtonsTitle(button)
			case 11...15:
				button.backgroundColor = Colors.colorOrange
				button.setTitleColor(Colors.colorWhite, for: .normal)
				setOperationButtonsTitle(button)
			case 16...18:
				button.backgroundColor = Colors.colorGray
				button.setTitleColor(Colors.colorBlack, for: .normal)
				setOperationButtonsTitle(button)
			default: break
			}
		}
	}

	func setRowsButtons() {
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

	func makeConstraints() {
		for button in buttons where button.tag != 0 {
			button.snp.makeConstraints { make in
				make.width.equalTo(button.snp.height).multipliedBy(1)
			}
		}

		fifthRowButtons.snp.makeConstraints { make in
			var equalBut = CalculatorButtons(frame: .zero)
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

		resultLabel.snp.makeConstraints { make in
			make.leading.equalTo(self).offset(15)
			make.trailing.equalTo(self).offset(-17)
			make.bottom.equalTo(buttonsStackView.snp.top).offset(-8)
			make.height.equalTo(113)
		}
	}
}
