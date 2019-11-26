//
//  ButtonView.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit
import SnapKit

final class ButtonView: UIView
{
	enum `Type`
	{
		case number(Int)
		case decimal(String)
		case mainOperator(String, UIImage? = nil)
		case other(String, UIImage? = nil)
	}

	typealias Action = (ButtonView) -> Void

	// MARK: Properties
	var title: String

	// MARK: Private properties
	private var color: UIColor
	private var image: UIImage?
	private var textColor: UIColor
	private var textSize: CGFloat
	private var tapHandler: Action
	private lazy var button: UIButton = {

		let button = UIButton()

		if image != nil {
			button.imageView?.contentMode = .scaleAspectFit
			button.setImage(image, for: .normal)
			button.setImageTintColor(textColor, for: .normal)
			button.setImageTintColor(textColor, for: .highlighted)
		}
		else {
			button.setTitle(title, for: .normal)
		}

		if let lighterColor = backgroundColor?.lighter(by: 25) {
			button.setBackgroundColor(lighterColor, for: .highlighted)
		}

		button.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: textSize)
		button.setTitleColor(self.textColor, for: .normal)
		button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
		button.setBackgroundColor(textColor, for: .selected)
		button.setTitleColor(color, for: .selected)
		button.setImageTintColor(color, for: .selected)

		button.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)

		return button
	}()

	// MARK: Initialization
	init(type: Type, backgroundColor: UIColor, textColor: UIColor, textSize: CGFloat = 36, tapHandler: @escaping Action) {
		var title = ""
		switch type {
		case .number(let number):
			title = "\(number)"
		case .decimal(let text):
			title = text
		case let .other(text, image):
			title = text
			self.image = image
		case let .mainOperator(text, image):
			title = text
			self.image = image
		}
		self.title = title
		self.tapHandler = tapHandler
		self.color = backgroundColor
		self.textColor = textColor
		self.textSize = textSize
		super.init(frame: .zero)
		setup()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Life cycle
	override func layoutSubviews() {
		layer.cornerRadius = min(bounds.width, bounds.height) / 2
		button.layer.cornerRadius = min(bounds.width, bounds.height) / 2
		if frame.width > frame.height + 1 {
			setLongButton()
		}
		if image != nil {
			setImageOffset()
		}
	}

	// MARK: Private methods
	private func setup() {
		backgroundColor = color
		addSubview(button)
		setConstraints()
	}

	private func setConstraints() {
		button.snp.makeConstraints { maker in
			maker.edges.equalToSuperview()
		}
	}

	private func setImageOffset() {
		let imageOffset = frame.width / 2.9
		button.imageEdgeInsets = UIEdgeInsets(top: imageOffset,
											  left: imageOffset,
											  bottom: imageOffset,
											  right: imageOffset)
	}

	private func setLongButton() {
		button.contentHorizontalAlignment = .left
		button.titleLabel?.sizeToFit()
		let leftOffset = (frame.height / 2) - ((button.titleLabel?.frame.width ?? 0) / 2)
		button.titleEdgeInsets = UIEdgeInsets(top: button.contentEdgeInsets.top,
											  left: leftOffset,
											  bottom: 0,
											  right: 0)
	}

	// MARK: Methods
	func setTitle(_ text: String) {
		guard image == nil else { return }
		button.setTitle(text, for: .normal)
	}

	func select() {
		button.isSelected = true
	}

	func deselect() {
		button.isSelected = false
	}
}

// MARK: - Actions
@objc private extension ButtonView
{
	private func action(_ sender: ButtonView) {
		tapHandler(self)
	}
}
