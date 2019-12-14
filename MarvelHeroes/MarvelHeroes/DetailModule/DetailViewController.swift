//
//  DetailViewController.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 06.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import  SnapKit

final class DetailViewController: UIViewController
{
	private let sizeOfTextDescriptionTextView: CGFloat = 20
	private let sizeOfTextNameLabel: CGFloat = 50

	private lazy var characterImage: UIImageView = {
		let imageView = UIImageView()
		if let path = presenter.getCharacter().thumbnail.path,
			let imageExtension = presenter.getCharacter().thumbnail.imageExtension {
			let urlString = "\(path).\(imageExtension)"
			presenter.getCharacterImage(imageUrl: urlString) { image in
				imageView.image = image
			}
		}
		gradient.colors = [UIColor.white.withAlphaComponent(0.3).cgColor, UIColor.white.cgColor]
		imageView.layer.insertSublayer(gradient, at: 0)
		return imageView
	}()

	private lazy var descriptionTextView: UITextView = {
		let textView = UITextView()
		textView.font = UIFont.systemFont(ofSize: sizeOfTextDescriptionTextView)
		textView.backgroundColor = .clear
		textView.text = presenter.getCharacter().description
		textView.isEditable = false
		return textView
	}()

	private lazy var nameLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textAlignment = .left
		label.font = UIFont.boldSystemFont(ofSize: sizeOfTextNameLabel)
		label.text = presenter.getCharacter().name
		label.numberOfLines = 0
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private let gradient = CAGradientLayer()
	private let presenter: IDetailPresenter

	init(presenter: IDetailPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(characterImage)
		view.addSubview(nameLabel)
		view.addSubview(descriptionTextView)
		updateUI()
		makeConstraints()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		gradient.frame = characterImage.bounds
	}
}

private extension DetailViewController
{
	func updateUI() {
		view.backgroundColor = .white
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		navigationItem.largeTitleDisplayMode = .never
	}

	func makeConstraints() {

		characterImage.snp.makeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
			make.bottom.equalToSuperview().dividedBy(2)
		}

		nameLabel.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.leading.trailing.equalToSuperview().inset(10)
		}

		descriptionTextView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().offset(10)
			make.top.equalTo(nameLabel.snp.bottom).offset(10)
			make.bottom.equalTo(characterImage.snp.bottom)
		}
	}
}
