//
//  CalculatorView.swift
//  Calculator
//
//  Created by Иван Медведев on 19/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorView: UIView
{
	let horizontalStackViewFirstRow = UIStackView()
	let horizontalStackViewSecondRow = UIStackView()
	let horizontalStackViewThirdRow = UIStackView()
	let horizontalStackViewFourthRow = UIStackView()
	let horizontalStackViewFifthRow = UIStackView()
	let verticalStackView = UIStackView()
	var buttons: [UIButton] = []
	var buttonsLabels: [UILabel] = []
	let resultLabel = UILabel()

	weak var delegate: CalculatorViewDelegate?

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.translatesAutoresizingMaskIntoConstraints = false
		paintBackground()
		settingsForStackViews()
		createButtonsWithSettings()
		createResultLabel()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		assertionFailure("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		// Закругляем кнопки
		self.roundButtons()
	}

	func paintBackground() {
		self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
	}

	func settingsForStackViews() {
		var horizontalStackViews: [UIStackView] = []

		horizontalStackViews.append(self.horizontalStackViewFirstRow)
		horizontalStackViews.append(self.horizontalStackViewSecondRow)
		horizontalStackViews.append(self.horizontalStackViewThirdRow)
		horizontalStackViews.append(self.horizontalStackViewFourthRow)
		horizontalStackViews.append(self.horizontalStackViewFifthRow)

		// Настройки для горизонтальных stackViews
		horizontalStackViews.forEach { stackView in
			stackView.axis = .horizontal
			stackView.alignment = .fill
			stackView.distribution = .equalSpacing
			stackView.translatesAutoresizingMaskIntoConstraints = false
		}

		// Настройки для вертикального stackView
		self.verticalStackView.axis = .vertical
		self.verticalStackView.alignment = .fill
		self.verticalStackView.distribution = .equalSpacing
		self.verticalStackView.translatesAutoresizingMaskIntoConstraints = false
		self.verticalStackView.spacing = 14

		// Добавляем горизонтальные stackViews в вертикальный stackView
		self.verticalStackView.addArrangedSubview(self.horizontalStackViewFirstRow)
		self.verticalStackView.addArrangedSubview(self.horizontalStackViewSecondRow)
		self.verticalStackView.addArrangedSubview(self.horizontalStackViewThirdRow)
		self.verticalStackView.addArrangedSubview(self.horizontalStackViewFourthRow)
		self.verticalStackView.addArrangedSubview(self.horizontalStackViewFifthRow)

		// Добавляем вертикальный stackView на экран
		self.addSubview(self.verticalStackView)

		// Добавляем constraints stackViews
		self.makeStackViewsConstraints()
	}

	func makeStackViewsConstraints() {
		NSLayoutConstraint.activate([

			// Привязываем вертикальный stackView к низу и бокам экрана c отступом в 16 единиц
			self.verticalStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor,
														   constant: Constants.verticalStackViewBottomConstraint),
			self.verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
															constant: Constants.verticalStackViewLeadingConstraint),
			self.verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
															 constant: Constants.verticalStackViewTrailingConstraint),

			// Добавляем constraints (height) для горизонтальных stackViews
			self.horizontalStackViewFirstRow.heightAnchor.constraint(equalTo: self.horizontalStackViewSecondRow.heightAnchor),
			self.horizontalStackViewFirstRow.heightAnchor.constraint(equalTo: self.horizontalStackViewThirdRow.heightAnchor),
			self.horizontalStackViewFirstRow.heightAnchor.constraint(equalTo: self.horizontalStackViewFourthRow.heightAnchor),
			self.horizontalStackViewFirstRow.heightAnchor.constraint(equalTo: self.horizontalStackViewFifthRow.heightAnchor),
			])
	}

	func createButtonsWithSettings() {
		for index in 0 ..< Constants.numberOfButtons {
			let button = UIButton()
			buttons.append(button)

			// Добавляем кнопки в stackViews
			switch index {
			case 0 ..< 4:
				self.horizontalStackViewFirstRow.addArrangedSubview(button)
			case 4 ..< 8:
				self.horizontalStackViewSecondRow.addArrangedSubview(button)
			case 8 ..< 12:
				self.horizontalStackViewThirdRow.addArrangedSubview(button)
			case 12 ..< 16:
				self.horizontalStackViewFourthRow.addArrangedSubview(button)
			case 16 ..< 19:
				self.horizontalStackViewFifthRow.addArrangedSubview(button)
			default:
				assertionFailure("Создано больше 19 кнопок. Лишняя трата ресурсов.")
			}
		}

		// Добавляем кнопкам constraints
		self.makeButtonsConstraints()

		// Красим кнопочки
		self.paintButtons()

		// Добавляем текст на кнопки
		self.createLabelsForButtonsWithSettings()

		// Добавляем действия
		self.addActionsForButtons()
	}

	func makeButtonsConstraints() {

		// Выставляем отступы в первой строке для того, чтобы рассчитать высоту и ширину кнопок
		// Пытался делать через spacing у stackView. Почему-то не работало.
		NSLayoutConstraint.activate([
			buttons[0].trailingAnchor.constraint(equalTo: buttons[1].leadingAnchor,
												 constant: Constants.spaceBetweenButtonsInRow),
			buttons[1].trailingAnchor.constraint(equalTo: buttons[2].leadingAnchor,
												 constant: Constants.spaceBetweenButtonsInRow),
			buttons[2].trailingAnchor.constraint(equalTo: buttons[3].leadingAnchor,
												 constant: Constants.spaceBetweenButtonsInRow),
			])

		for (index, button) in buttons.enumerated() {
			button.translatesAutoresizingMaskIntoConstraints = false

			// Настройки для кнопки 0, которая в массиве находится под индексом 16
			if index == 16, let firstButtonWidthAnchor = self.buttons.first?.widthAnchor {
				NSLayoutConstraint.activate([
					button.heightAnchor.constraint(equalTo: firstButtonWidthAnchor),
					button.widthAnchor.constraint(equalTo: firstButtonWidthAnchor,
												  multiplier: 2,
												  constant: -Constants.spaceBetweenButtonsInRow),
					])
			}
				// Настройки для всех остальных кнопок
			else if index > 0, let firstButtonWidthAnchor = self.buttons.first?.widthAnchor {
				NSLayoutConstraint.activate([
					button.widthAnchor.constraint(equalTo: firstButtonWidthAnchor),
					button.heightAnchor.constraint(equalTo: firstButtonWidthAnchor),
					])
			}
		}
	}

	func roundButtons() {
		buttons.forEach { button in
			button.layer.cornerRadius = button.bounds.height / 2
		}
	}

	func paintButtons() {
		for index in 0 ..< Constants.numberOfButtons {
			switch index {
			case 0 ..< 3:
				buttons[index].backgroundColor = .lightGray
			case 4, 5, 6, 8, 9, 10, 12, 13, 14, 16, 17:
				buttons[index].backgroundColor = .darkGray
			case 3, 7, 11, 15, 18:
				buttons[index].backgroundColor = .orange
			default:
				assertionFailure("Красим не существующую кнопку.")
			}
		}
	}

	func createLabelsForButtonsWithSettings() {

		for index in 0 ..< buttons.count {
			let label = UILabel()
			label.font = UIFont(name: "FiraSans-Regular", size: 32)
			buttonsLabels.append(label)

			switch index {
			case 0: label.text = "AC"; label.textColor = .black
			case 1: label.text = "⁺⁄₋"; label.textColor = .black
			case 2: label.text = "%"; label.textColor = .black
			case 3: label.text = "÷"; label.textColor = .white; label.font = UIFont(name: "FiraSans-Regular", size: 40)
			case 4: label.text = "7"; label.textColor = .white
			case 5: label.text = "8"; label.textColor = .white
			case 6: label.text = "9"; label.textColor = .white
			case 7: label.text = "×"; label.textColor = .white; label.font = UIFont(name: "FiraSans-Regular", size: 40)
			case 8: label.text = "4"; label.textColor = .white
			case 9: label.text = "5"; label.textColor = .white
			case 10: label.text = "6"; label.textColor = .white
			case 11: label.text = "−"; label.textColor = .white; label.font = UIFont(name: "FiraSans-Regular", size: 40)
			case 12: label.text = "1"; label.textColor = .white
			case 13: label.text = "2"; label.textColor = .white
			case 14: label.text = "3"; label.textColor = .white
			case 15: label.text = "+"; label.textColor = .white; label.font = UIFont(name: "FiraSans-Regular", size: 40)
			case 16: label.text = "0"; label.textColor = .white
			case 17: label.text = ","; label.textColor = .white
			case 18: label.text = "="; label.textColor = .white; label.font = UIFont(name: "FiraSans-Regular", size: 40)
			default: assertionFailure("Создается лишний label, который нигде не используется.")
			}
			buttons[index].addSubview(label)

			// Добавляем тексту constraints
			self.makeButtonsLabelsConstraints()
		}
	}

	func makeButtonsLabelsConstraints() {
		for (index, label) in buttonsLabels.enumerated() {

			guard let superViewCenterX = label.superview?.centerXAnchor,
				let superViewCenterY = label.superview?.centerYAnchor else { return }

			label.translatesAutoresizingMaskIntoConstraints = false
			if index == 16 {
				NSLayoutConstraint.activate([
					label.centerXAnchor.constraint(equalTo: buttonsLabels[0].centerXAnchor),
					label.centerYAnchor.constraint(equalTo: superViewCenterY),
					])
			}
			else {
				NSLayoutConstraint.activate([
					label.centerXAnchor.constraint(equalTo: superViewCenterX),
					label.centerYAnchor.constraint(equalTo: superViewCenterY),
					])
			}
		}
	}

	func addActionsForButtons() {
		for button in buttons {
			button.addTarget(self, action: #selector(self.clickedButton), for: .touchUpInside)
		}
	}

	@objc func clickedButton(sender: UIButton) {
		guard let text = (sender.subviews.last as? UILabel)?.text else { return }
		delegate?.clickedButton(text)
	}

	func createResultLabel() {
		self.resultLabel.text = "0"

		self.resultLabel.adjustsFontSizeToFitWidth = true
		self.resultLabel.textAlignment = .right

		self.resultLabel.font = UIFont(name: "FiraSans-Light", size: 75)
		self.resultLabel.textColor = .white

		self.resultLabel.isUserInteractionEnabled = true
		let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(deleteSwipe))
		swipeGestureRecognizer.direction = [.left, .right]
		self.resultLabel.addGestureRecognizer(swipeGestureRecognizer)
		self.addSubview(self.resultLabel)

		self.resultLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			self.resultLabel.bottomAnchor.constraint(equalTo: self.verticalStackView.topAnchor,
													 constant: Constants.spaceBetweenLabelAndVerticalStackView),
			self.resultLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
													  constant: Constants.verticalStackViewLeadingConstraint),
			self.resultLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
													   constant: Constants.verticalStackViewTrailingConstraint),
			])
	}

	@objc func deleteSwipe() {
		self.resultLabel.text?.removeLast()
		if self.resultLabel.text?.count == 1 && self.resultLabel.text?.first == "-" {
			self.resultLabel.text = "-0"
		}
		else if self.resultLabel.text?.count == 0 {
			self.resultLabel.text = "0"
		}
	}
}
