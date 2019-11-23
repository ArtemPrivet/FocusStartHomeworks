//
//  TopView.swift
//  Calculator
//
//  Created by Саша Руцман on 17/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

protocol TappedButtonsDelegate: AnyObject
{
	func tappedButtons(_ sender: UIButton)
	func deleteNumber()
}

final class CalculatorView: UIView
{
	lazy var topView: UIView = {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		view.backgroundColor = .black
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	var calculatingLabel: UILabel = {
		let calculatingLabel = UILabel()
		//self.topView.addSubview(calculatingLabel)
		calculatingLabel.translatesAutoresizingMaskIntoConstraints = false
		calculatingLabel.text = "0"
		calculatingLabel.textColor = .white
		calculatingLabel.textAlignment = .right
		calculatingLabel.font = UIFont(name: "FiraSans-Light", size: 94)
		return calculatingLabel
	}()
	weak var delegate: TappedButtonsDelegate?
	var ACButton = UIButton()
	var plusOrMinusButton = UIButton()
	var divisionWithoutRemainderButton = UIButton()
	var divisionButton = UIButton()
	var multiplicationButton = UIButton()
	var minusButton = UIButton()
	var plusButton = UIButton()
	var resultButton = UIButton()
	var zeroButton = UIButton()
	var commaButton = UIButton()
	var numbers: [UIButton] = []
	let stackView1 = UIStackView() //AC , +/- ...
	let stackView2 = UIStackView() //7,8,9,*
	let stackView3 = UIStackView() //4,5,6,-
	let stackView4 = UIStackView() //1,2,3,+
	let stackView5 = UIStackView() //0, stackview7
	let stackView6 = UIStackView() //stackView1-5
	let stackView7 = UIStackView() //",",=

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .black
		self.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(topView)
		topView.addSubview(calculatingLabel)
		createButtons()
		stackViewSetupSettings(stackView: stackView1,
							   buttons: [
								ACButton,
								plusOrMinusButton,
								divisionWithoutRemainderButton,
								divisionButton,
			])
		stackViewSetupSettings(stackView: stackView2,
							   buttons: [
								numbers[6],
								numbers[7],
								numbers[8],
								multiplicationButton,
			])
		stackViewSetupSettings(stackView: stackView3,
							   buttons: [
								numbers[3],
								numbers[4],
								numbers[5],
								minusButton,
			])
		stackViewSetupSettings(stackView: stackView4,
							   buttons: [
								numbers[0],
								numbers[1],
								numbers[2],
								plusButton,
			])
		stackView5Settings()
		setupSettingsForMainStackView()
		makeConstraints()
		addGesture()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setTitleForLabel(text: String) {
		calculatingLabel.text = text
	}

	func setupSettingsForMainStackView() {
		stackView6.axis = NSLayoutConstraint.Axis.vertical
		stackView6.distribution = UIStackView.Distribution.fillEqually
		stackView6.alignment = UIStackView.Alignment.center
		stackView6.spacing = 14
		stackView6.translatesAutoresizingMaskIntoConstraints = false
		stackView6.addArrangedSubview(stackView1)
		stackView6.addArrangedSubview(stackView2)
		stackView6.addArrangedSubview(stackView3)
		stackView6.addArrangedSubview(stackView4)
		stackView6.addArrangedSubview(stackView5)
		self.addSubview(stackView6)
	}

	func stackView5Settings() {
		stackView5.axis = NSLayoutConstraint.Axis.horizontal
		stackView5.distribution = UIStackView.Distribution.fillEqually
		stackView5.alignment = UIStackView.Alignment.center
		stackView7.axis = NSLayoutConstraint.Axis.horizontal
		stackView7.distribution = UIStackView.Distribution.fillEqually
		stackView7.alignment = UIStackView.Alignment.center
		stackView5.spacing = 14
		stackView7.spacing = 14
		stackView7.addArrangedSubview(commaButton)
		stackView7.addArrangedSubview(resultButton)
		stackView5.addArrangedSubview(zeroButton)
		stackView5.addArrangedSubview(stackView7)
		stackView5.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(stackView5)
		commaButton.heightAnchor.constraint(equalTo: commaButton.widthAnchor, multiplier: 1.0).isActive = true
		resultButton.heightAnchor.constraint(equalTo: resultButton.widthAnchor, multiplier: 1.0).isActive = true
		zeroButton.heightAnchor.constraint(equalTo: resultButton.widthAnchor, multiplier: 1.0).isActive = true
	}

	func createButton(title: String, color: Int, tag: Int) -> UIButton {
		let button = UIButton(type: .system)
		button.setTitle(title, for: .normal)
		if color == 0 {
			button.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
			button.setTitleColor(.white, for: .normal)
		}
		else if color == 1 {
			button.backgroundColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
			button.setTitleColor(.white, for: .normal)
		}
		else if color == 2 {
			button.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
			button.setTitleColor(.black, for: .normal)		}
		else if color == 3 {
			button.backgroundColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
			button.setTitleColor(.black, for: .normal)
		}
		let buttonWidth = (self.frame.width - 74) / 4
		button.titleLabel?.font = UIFont(name: "FiraSans-Light", size: 32)
		button.layer.cornerRadius = buttonWidth / 2
		button.clipsToBounds = true
		button.tag = tag
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
		return button
	}

	@objc func buttonTapped(_ sender: UIButton) {
		delegate?.tappedButtons(sender)
	}

	@objc func deleteButtonTapped(_ sender: UISwipeGestureRecognizer) {
		delegate?.deleteNumber()
	}

	func createButtons() {
		createButtonsWithNumbers()
		ACButton = createButton(title: "AC", color: 2, tag: 10)
		plusOrMinusButton = createButton(title: "+/-", color: 3, tag: 11)
		divisionWithoutRemainderButton = createButton(title: "%", color: 3, tag: 12)
		divisionButton = createButton(title: "/", color: 1, tag: 13)
		multiplicationButton = createButton(title: "x", color: 1, tag: 14)
		minusButton = createButton(title: "-", color: 1, tag: 15)
		plusButton = createButton(title: "+", color: 1, tag: 16)
		resultButton = createButton(title: "=", color: 1, tag: 17)
		zeroButton = createButton(title: "0", color: 0, tag: 0)
		zeroButton.contentHorizontalAlignment = .left
		zeroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 0)
		commaButton = createButton(title: ",", color: 0, tag: 18)
	}

	func createButtonsWithNumbers() {
		for title in 0..<9 {
			let button = UIButton(type: .system)
			button.setTitle("\(title + 1)", for: .normal)
			button.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
			button.layer.cornerRadius = (self.frame.width - 74) / 8
			button.clipsToBounds = true
			button.titleLabel?.font = UIFont(name: "FiraSans-Light", size: 32)
			button.setTitleColor(.white, for: .normal)
			button.tag = title + 1
			button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
			numbers.append(button)
		}
	}

	func makeConstraints() {
		topView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		topView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		topView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		topView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1 / 3).isActive = true
		stackView6.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		stackView6.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		stackView6.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8).isActive = true
		stackView6.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
		stackView1.leftAnchor.constraint(equalTo: stackView6.leftAnchor, constant: 16).isActive = true
		stackView1.rightAnchor.constraint(equalTo: stackView6.rightAnchor, constant: -16).isActive = true
		stackView2.leftAnchor.constraint(equalTo: stackView6.leftAnchor, constant: 16).isActive = true
		stackView2.rightAnchor.constraint(equalTo: stackView6.rightAnchor, constant: -16).isActive = true
		stackView3.leftAnchor.constraint(equalTo: stackView6.leftAnchor, constant: 16).isActive = true
		stackView3.rightAnchor.constraint(equalTo: stackView6.rightAnchor, constant: -16).isActive = true
		stackView4.leftAnchor.constraint(equalTo: stackView6.leftAnchor, constant: 16).isActive = true
		stackView4.rightAnchor.constraint(equalTo: stackView6.rightAnchor, constant: -16).isActive = true
		stackView5.leftAnchor.constraint(equalTo: stackView6.leftAnchor, constant: 16).isActive = true
		stackView5.rightAnchor.constraint(equalTo: stackView6.rightAnchor, constant: -16).isActive = true
		calculatingLabel.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 16).isActive = true
		calculatingLabel.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -16).isActive = true
		calculatingLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 99).isActive = true
		calculatingLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -8).isActive = true
	}

	func stackViewSetupSettings(stackView: UIStackView, buttons: [UIButton]) {
		stackView.axis = NSLayoutConstraint.Axis.horizontal
		stackView.distribution = UIStackView.Distribution.fillEqually
		stackView.alignment = UIStackView.Alignment.center
		stackView.spacing = 14
		stackView.addArrangedSubview(buttons[0])
		stackView.addArrangedSubview(buttons[1])
		stackView.addArrangedSubview(buttons[2])
		stackView.addArrangedSubview(buttons[3])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(stackView)
		buttons[0].heightAnchor.constraint(equalTo: buttons[0].widthAnchor, multiplier: 1.0).isActive = true
		buttons[1].heightAnchor.constraint(equalTo: buttons[1].widthAnchor, multiplier: 1.0).isActive = true
		buttons[2].heightAnchor.constraint(equalTo: buttons[2].widthAnchor, multiplier: 1.0).isActive = true
		buttons[3].heightAnchor.constraint(equalTo: buttons[3].widthAnchor, multiplier: 1.0).isActive = true
	}

	func addGesture() {
		calculatingLabel.isUserInteractionEnabled = true
		let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(deleteButtonTapped))
		rightSwipeGesture.direction = .right
		let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(deleteButtonTapped))
		leftSwipeGesture.direction = .left
		calculatingLabel.addGestureRecognizer(rightSwipeGesture)
		calculatingLabel.addGestureRecognizer(leftSwipeGesture)
	}
}
