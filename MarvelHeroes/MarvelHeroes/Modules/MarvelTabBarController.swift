//
//  MarvelTabBarController.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 07.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

final class MarvelTabBarController: UITabBarController
{

	private let comicsVC = Factory().createComicsModule()
	private let authorVC = Factory().createAuthorsModule()
	private let charactersVC = Factory().createCharactersModule()

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tabBar.shadowImage = UIImage()
		comicsVC.tabBarItem = UITabBarItem(title: "Comics", image: #imageLiteral(resourceName: "comic"), tag: 2)
		authorVC.tabBarItem = UITabBarItem(title: "Authors", image: #imageLiteral(resourceName: "writer"), tag: 3)

		self.addChild(UINavigationController(rootViewController: charactersVC))
		self.addChild(UINavigationController(rootViewController: comicsVC))
		self.addChild(UINavigationController(rootViewController: authorVC))
 	}
}
