//
//  TabBarViewController.swift
//  MarvelHeroes
//
//  Created by Антон on 07.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController
{
	override func viewDidLoad() {
		super.viewDidLoad()
		//hero screen
		let presenterHero = MainScreenPresenter(presenterType: .heroScreen)
		let heroScreen = MainScreenViewController(presenter: presenterHero)
		let navigationControllerHeroScreens = UINavigationController(rootViewController: heroScreen)
		//comics screen
		let presenterComics = MainScreenPresenter(presenterType: .comicsScreen)
		let comicsScreen = MainScreenViewController(presenter: presenterComics)
		let navigationControllerComicsScreen = UINavigationController(rootViewController: comicsScreen)
		//authors screen
		let presenterAuthors = MainScreenPresenter(presenterType: .authorsScreen)
		let authorsScreen = MainScreenViewController(presenter: presenterAuthors)
		let navigationControllerAuthorsScreen = UINavigationController(rootViewController: authorsScreen)
		//tab bar
		navigationControllerHeroScreens.tabBarItem = UITabBarItem(title: "Heroes",
																  image: #imageLiteral(resourceName: "shield"), tag: 0)
		navigationControllerComicsScreen.tabBarItem = UITabBarItem(title: "Comics",
																   image: #imageLiteral(resourceName: "comic"), tag: 1)
		navigationControllerAuthorsScreen.tabBarItem = UITabBarItem(title: "Authors",
																	image: #imageLiteral(resourceName: "writer"), tag: 2)
		let tabBarList = [
			navigationControllerHeroScreens,
			navigationControllerComicsScreen,
			navigationControllerAuthorsScreen,
		]
		viewControllers = tabBarList
	}
}
