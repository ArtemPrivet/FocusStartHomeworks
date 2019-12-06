//
//  CharactersTableViewCell.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 03.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import UIKit
import SnapKit

final class CharactersTableViewCell: UITableViewCell
{
	var characterImageView = UIImageView()
	var nameLabel = UILabel()
	var descriptionLabel = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubview(characterImageView)
		addSubview(nameLabel)
		addSubview(descriptionLabel)
		makeConstraints()
		confirureViews()
	}
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
	}
	private func confirureViews() {
		//tabBarItem = UITabBarItem(title: "Heroes", image: UIImage(named: "shield"), selectedImage: nil)
		characterImageView.layer.cornerRadius = 30
		characterImageView.clipsToBounds = true
		nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
		nameLabel.textAlignment = .left
		descriptionLabel.textAlignment = .left
	}
	private func makeConstraints() {
		characterImageView.snp.makeConstraints { maker in
			maker.width.height.equalTo(60)
			maker.top.equalToSuperview().offset(8)
			maker.leading.equalToSuperview().offset(16)
			maker.bottom.equalToSuperview().offset(-8).priority(249)
			maker.bottom.lessThanOrEqualToSuperview().offset(-8)
		}
		nameLabel.snp.makeConstraints { maker in
			maker.leading.equalTo(characterImageView.snp.trailing).offset(8)
			maker.top.equalToSuperview().offset(8)
			maker.trailing.equalToSuperview().offset(-8)
		}
		descriptionLabel.snp.makeConstraints { maker in
			maker.leading.equalTo(nameLabel.snp.leading)
			maker.bottom.equalToSuperview().offset(-8)
			maker.top.equalTo(nameLabel.snp.bottom)
			maker.trailing.equalToSuperview().offset(-8)
		}
	}
}
