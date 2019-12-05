//
//  AuthorViewController.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/2/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

class AuthorViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		self.title = "Author"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "✍️ Author"
	}
}
