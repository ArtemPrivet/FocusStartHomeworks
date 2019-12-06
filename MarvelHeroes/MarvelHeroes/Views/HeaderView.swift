//
//  HeaderView.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 05.12.2019.
//

import UIKit

final class HeaderView: UIView
{
	// MARK: Private properties
	private var titleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = .boldSystemFont(ofSize: 32)
		label.numberOfLines = 0
		label.backgroundColor = .clear
		return label
	}()

	private lazy var descriptionTextView: UITextView = {
		let textView = UITextView()
		textView.textAlignment = .left
		textView.font = .systemFont(ofSize: 20)
		textView.isEditable = false
		textView.isSelectable = false
		textView.backgroundColor = .clear
		return textView
	}()

	private var titleLabelSize: CGSize = .zero
	private var descriptionTextViewSize: CGSize = .zero
	private let maxDescriptionTextViewHeight: CGFloat = 200

	// MARK: Initializations
	init(withWidth width: CGFloat, titleText: String?, descriptionText: String?) {
		super.init(frame: .zero)
		setup(withWidth: width, title: titleText, description: descriptionText)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Private methods
	private func setup(withWidth width: CGFloat, title: String?, description: String?) {
		layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		addSubview(titleLabel)
		titleLabel.text = title
		let labelHeight = calculateHeight(titleLabel, byWidth: width)
		titleLabelSize =
			CGSize(width: width - layoutMargins.left + layoutMargins.right,
				   height: labelHeight)

		guard let text = description?.trimmingCharacters(in: .whitespaces), text.isEmpty == false else { return }
		addSubview(descriptionTextView)
		descriptionTextView.text = text

		let textViewHeight = calculateHeight(descriptionTextView, byWidth: width)
		descriptionTextViewSize =
			CGSize(width: width - layoutMargins.left - layoutMargins.right,
				   height: min(textViewHeight + 10, maxDescriptionTextViewHeight))
	}

	private func calculateHeight(_ view: UIView, byWidth width: CGFloat) -> CGFloat {
		view.systemLayoutSizeFitting(
			CGSize(width: width - layoutMargins.left - layoutMargins.right,
				   height: UIView.layoutFittingCompressedSize.height),
			withHorizontalFittingPriority: .required,
			verticalFittingPriority: .fittingSizeLevel)
		.height
	}

	override func layoutSubviews() {
		titleLabel.frame = CGRect(origin: CGPoint(x: layoutMargins.left,
												  y: layoutMargins.top),
								  size: titleLabelSize)

		descriptionTextView.frame = CGRect(origin: CGPoint(x: layoutMargins.left,
														   y: titleLabel.frame.maxY),
										   size: descriptionTextViewSize)

		frame = CGRect(origin: .zero,
					   size: CGSize(width: titleLabelSize.width + layoutMargins.left + layoutMargins.right,
									height: titleLabelSize.height + descriptionTextViewSize.height + layoutMargins.top + layoutMargins.bottom))
	}
}
