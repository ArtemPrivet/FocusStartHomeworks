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
		case string(String)
	}

	typealias Action = (String) -> Void

	// MARK: Properties
	var title: String?

	// MARK: Private properties
	private var color: UIColor?
	private var textColor: UIColor?
	private var tapHandler: Action
	private lazy var button: UIButton = {
		let button = UIButton()
		button.setTitle(self.title, for: .normal)
		button.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 36)
		button.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
		button.setTitleColor(self.textColor, for: .normal)
		button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
		return button
	}()

	// MARK: Initialization
	init(type: Type, backgroundColor: UIColor, textColor: UIColor, tapHandler: @escaping Action) {
		var title = ""
		switch type {
		case .number(let number): title = "\(number)"
		case .string(let  text): title = text
		}
		self.title = title
		self.tapHandler = tapHandler
		self.color = backgroundColor
		self.textColor = textColor
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
			button.contentHorizontalAlignment = .left
			button.titleLabel?.sizeToFit()
			let leftOffset = (frame.height / 2) - ((button.titleLabel?.frame.width ?? 0) / 2)
			button.titleEdgeInsets = UIEdgeInsets(top: button.contentEdgeInsets.top, left: leftOffset, bottom: 0, right: 0)
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
}

// MARK: - Actions
@objc private extension ButtonView
{
	private func action(_ sender: UIButton) {
		guard let title = sender.titleLabel?.text else { return }
		tapHandler(title)
	}
}
