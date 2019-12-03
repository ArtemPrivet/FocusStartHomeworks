//
//  AuthorsViewController.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 03.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class AuthorsViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		setupNavigationBar()
	}
	
	private func setupNavigationBar() {
		navigationController?.navigationBar.prefersLargeTitles = true
		let searchController = UISearchController(searchResultsController: nil)
		navigationItem.searchController = searchController
		title = "👨‍🏫Authors"
		tabBarItem = UITabBarItem(title: "Authors", image: #imageLiteral(resourceName: "writer"), tag: 3)
	}
}
