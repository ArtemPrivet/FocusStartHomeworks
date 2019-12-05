//
//  DetailViewController.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/2/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	private var presenter: IDetailPresenter
	private var heroName = UILabel()
	private var heroDescription = UITextView()
	private var heroComicsTableView = UITableView()
	private var heroImage: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFill
		return view
	}()

	init(presenter: IDetailPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		view.addSubview(heroName)
		view.addSubview(heroDescription)
		view.addSubview(heroImage)
		view.addSubview(heroComicsTableView)
		heroName.text = presenter.getHero().name
		heroDescription.text = presenter.getHero().resultDescription
		heroImage.image = {
			let image = UIImageView()
			let imagePath = presenter.getHero().thumbnail
			if let url = URL(string: "\(imagePath.path)/standard_xlarge.\(imagePath.thumbnailExtension)"),
				let heroDataImage = try? Data(contentsOf: url){
				image.image = UIImage(data: heroDataImage)
			}
			return image.image
		}()
		setupUI()
		setConstraints()
	}

	private func setupUI() {
		heroName.isOpaque = false
		heroName.numberOfLines = 0
		heroName.font = UIFont(name: "Helvetica", size: 34)
		heroDescription.isOpaque = false
		heroDescription.isEditable = false
		heroDescription.font = UIFont(name: "Helvetica", size: 18)
		heroImage.alpha = 0.3
	}

	private func setConstraints() {
		heroImage.translatesAutoresizingMaskIntoConstraints = false
		heroDescription.translatesAutoresizingMaskIntoConstraints = false
		heroName.translatesAutoresizingMaskIntoConstraints = false
		heroComicsTableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			heroName.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
			heroName.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
			heroName.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
			heroDescription.topAnchor.constraint(equalTo: heroName.bottomAnchor, constant: 8),
			heroDescription.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
			heroDescription.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
			heroDescription.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/3),
			heroComicsTableView.topAnchor.constraint(equalTo: heroDescription.bottomAnchor, constant: 6),
			heroComicsTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
			heroComicsTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
			heroComicsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			heroImage.topAnchor.constraint(equalTo: self.view.topAnchor),
			heroImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
			heroImage.rightAnchor.constraint(equalTo: self.view.rightAnchor),
			heroImage.bottomAnchor.constraint(equalTo: heroDescription.bottomAnchor)
		])
	}
}
