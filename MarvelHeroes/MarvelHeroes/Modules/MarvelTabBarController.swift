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

	let comicsVC = Factory().createComicsModule()
	let authorVC = Factory().createAuthorsModule()
	let charactersVC = Factory().createCharactersModule()

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
