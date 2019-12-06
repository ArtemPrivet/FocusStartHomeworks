//
//  HeaderCollectionView.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 05.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.

import UIKit

final class HeaderCollectionView: UICollectionReusableView
{
	var imageView = UIImageView()
	var titleLabel = UILabel()
	var descriptionTextView = UITextView()
	var gradientContainerView = UIView()

	var animator: UIViewPropertyAnimator?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupImageView()
		setupVisualEffectBlur()
		setupGradientLayer()
		setupLabels()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupImageView() {
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.image = #imageLiteral(resourceName: "detailImageBG")
		imageView.alpha = 0.2
		addSubview(imageView)
		imageView.fillSuperview()
	}

	private func setupLabels() {
		let stackView = UIStackView()
		stackView.axis = .vertical

		if #available(iOS 13.0, *) {
			let strokeTextAttributes = [
				NSAttributedString.Key.strokeColor: UIColor.white,
				NSAttributedString.Key.foregroundColor: UIColor.label,
				NSAttributedString.Key.strokeWidth: -2.0,
				NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold),
				] as [NSAttributedString.Key: Any]
			titleLabel.attributedText = NSMutableAttributedString(string: "",
																  attributes: strokeTextAttributes)
		}
		else {
			titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
		}

		titleLabel.text = "Some Awesome Hero Here"
		titleLabel.numberOfLines = 0
		titleLabel.lineBreakMode = .byWordWrapping
		titleLabel.minimumScaleFactor = 0.5

		stackView.addArrangedSubview(titleLabel)

		if #available(iOS 13.0, *) {
			let strokeTextAttributes = [
				NSAttributedString.Key.strokeColor: UIColor.white,
				NSAttributedString.Key.foregroundColor: UIColor.label,
				NSAttributedString.Key.strokeWidth: -2.0,
				NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),
				] as [NSAttributedString.Key: Any]
			descriptionTextView.attributedText = NSMutableAttributedString(string: "",
																		   attributes: strokeTextAttributes)
		}
		else {
			descriptionTextView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
		}

		descriptionTextView.backgroundColor = .clear
		descriptionTextView.isScrollEnabled = true
		descriptionTextView.isEditable = false
		descriptionTextView.text = "No description"
		stackView.addArrangedSubview(descriptionTextView)

		stackView.spacing = 8

		addSubview(stackView)
		stackView.anchor(top: topAnchor, leading: leadingAnchor,
						 bottom: bottomAnchor, trailing: trailingAnchor,
						 padding: .init(top: bounds.height / 4, left: 16, bottom: 16, right: 16))
	}

	private func setupVisualEffectBlur() {
		let blurEffect = UIBlurEffect(style: .regular)
		let visualEffectView = UIVisualEffectView(effect: blurEffect)
		visualEffectView.alpha = 0

		addSubview(visualEffectView)
		visualEffectView.fillSuperview()

		animator = UIViewPropertyAnimator(duration: 3, curve: .linear,
										  animations: { visualEffectView.alpha = 1 })

		animator?.fractionComplete = 0
	}

	private func setupGradientLayer() {
		let gradientLayer = CAGradientLayer()

		if #available(iOS 13.0, *) {
			gradientLayer.colors = [
				UIColor.clear.cgColor,
				UIColor.systemBackground.cgColor,
			]
		}
		else { gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white] }

		gradientLayer.locations = [0, 1]

		let gradientContainerView = UIView()
		addSubview(gradientContainerView)
		gradientContainerView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
		gradientContainerView.layer.addSublayer(gradientLayer)

		// make it dynamic
		gradientLayer.frame = bounds
		gradientLayer.frame.origin.y -= bounds.height
	}
}
