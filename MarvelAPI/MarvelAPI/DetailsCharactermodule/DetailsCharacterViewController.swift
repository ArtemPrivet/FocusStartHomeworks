//
//  DetailsCharacterViewController.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class DetailsCharacterViewController: UIViewController {

	var titleLabel = UILabel()
	var bodyLabel = UILabel()
	
	var presenter: IDetailsCharacterPresenter
	
	init(presenter: IDetailsCharacterPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		setupViews()
		setupConstraints()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("DetailsViewController deinit")
	}
	
	private func setupViews() {
		self.view.addSubview(titleLabel)
		self.view.addSubview(bodyLabel)
		
		titleLabel.text = presenter.getCharacter().name
		bodyLabel.text = String(presenter.getCharacter().comics.items.count)
	}
	
	private func setupConstraints() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		bodyLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
			bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
			])
	}
}
