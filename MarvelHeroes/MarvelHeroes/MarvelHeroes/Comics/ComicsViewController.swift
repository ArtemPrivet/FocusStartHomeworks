//
//  ComicsViewController.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 04/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import UIKit

class ComicsViewController: UIViewController
{
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		self.navigationController?.navigationBar.topItem?.title = "Comics"
	}
}
