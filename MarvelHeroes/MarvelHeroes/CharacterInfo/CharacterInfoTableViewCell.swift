//
//  CharacterInfoTableViewCell.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 05.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import UIKit
import SnapKit

final class ComicsTableViewCell: UITableViewCell
{
	private var comicCover = UIImageView()
	private var comicLabel = UILabel()
	static let cellId = "cell"

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubViews()
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
	private func addSubViews() {
		addSubview(comicCover)
		addSubview(comicLabel)
	}
	private func confirureViews() {
		comicLabel.font = UIFont.boldSystemFont(ofSize: 16)
		comicLabel.textAlignment = .left
		comicLabel.numberOfLines = 0
		comicCover.contentMode = .scaleAspectFit
	}
	private func makeConstraints() {
		comicCover.snp.makeConstraints { maker in
			maker.width.height.equalTo(60)
			maker.top.equalToSuperview().offset(8)
			maker.leading.equalToSuperview().offset(16)
			maker.bottom.equalToSuperview().offset(-8).priority(249)
			maker.bottom.lessThanOrEqualToSuperview().offset(-8)
		}
		comicLabel.snp.makeConstraints { maker in
			maker.leading.equalTo(comicCover.snp.trailing).offset(8)
			maker.trailing.equalToSuperview().offset(-8)
			maker.centerY.equalToSuperview()
			maker.bottom.equalToSuperview().offset(-8)
		}
	}
	func set(comicCover: UIImage) {
		self.comicCover.image = comicCover
	}
	func set(text: String?) {
		comicLabel.text = text
	}
}
