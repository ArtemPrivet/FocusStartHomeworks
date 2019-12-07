//
//  ComicsViewController.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/2/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

final class ComicsViewController: UIViewController
{
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		self.title = "Comics"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "📚 Comics"
	}
}
