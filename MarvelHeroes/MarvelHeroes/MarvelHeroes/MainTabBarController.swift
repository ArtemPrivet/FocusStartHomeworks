//
//  MainTabBarController.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 04/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController
{
	let heroesVC = ModulesFactory().getHeroModule()
	let comicsVC = ComicsViewController()
	let authorsVC = AuthorsViewController()

	override func viewDidLoad() {
		super.viewDidLoad()
		viewControllers = [
			generateVC(rootVC: heroesVC, image: #imageLiteral(resourceName: "shield").withRenderingMode(.alwaysOriginal), title: "Heroes"),
			generateVC(rootVC: comicsVC, image: #imageLiteral(resourceName: "comic").withRenderingMode(.alwaysOriginal), title: "Comics"),
			generateVC(rootVC: authorsVC,
					   image: #imageLiteral(resourceName: "writer").withRenderingMode(.alwaysOriginal),
					   title: "Authors"),
		]
	}

	private func generateVC(rootVC: UIViewController, image: UIImage, title: String) -> UIViewController {
		let navigationVC = UINavigationController(rootViewController: rootVC)
		navigationVC.tabBarItem.image = image
		navigationVC.tabBarItem.title = title
		navigationVC.navigationBar.prefersLargeTitles = true
		navigationVC.navigationBar.barTintColor = .white
		return navigationVC
	}
}
