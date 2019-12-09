//
//  CharacterCell.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 06.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import SnapKit

final class CharacterCell: UITableViewCell
{
	var characterImageView = UIImageView()
	var nameLabel = UILabel()
	var descriptionLabel = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubview(characterImageView)
		addSubview(nameLabel)
		addSubview(descriptionLabel)
		configureCell()
		makeConstraints()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

	private func configureCell() {
		characterImageView.layer.cornerRadius = 30
		characterImageView.clipsToBounds = true
		nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
		nameLabel.textAlignment = .left
		descriptionLabel.textAlignment = .left
	}

	private func makeConstraints() {

		characterImageView.snp.makeConstraints { make in
			make.width.height.equalTo(60)
			make.top.equalToSuperview().offset(8)
			make.leading.equalToSuperview().offset(16)
			make.bottom.equalToSuperview().offset(-8).priority(249)
			make.bottom.lessThanOrEqualToSuperview().offset(-8)
		}

		nameLabel.snp.makeConstraints { make in
			make.leading.equalTo(characterImageView.snp.trailing).offset(8)
			make.top.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().offset(-8)
		}

		descriptionLabel.snp.makeConstraints { make in
			make.leading.equalTo(nameLabel.snp.leading)
			make.bottom.equalToSuperview().offset(-8)
			make.top.equalTo(nameLabel.snp.bottom)
			make.trailing.equalToSuperview().offset(-8)
		}
	}
}
