//
//  Factory.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/5/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

final class ModulesFactory
{
	func addTabBarViewController() -> UIViewController {
		let naviHeroVC = UINavigationController(rootViewController: getHeroModule())
		naviHeroVC.tabBarItem.image = UIImage(named: "shield")
		let naviComicsVC = UINavigationController(rootViewController: ComicsViewController())
		naviComicsVC.tabBarItem.image = UIImage(named: "comic")
		let naviAuthorVC = UINavigationController(rootViewController: AuthorViewController())
		naviAuthorVC.tabBarItem.image = UIImage(named: "writer")
		let tabBarController = UITabBarController()
		tabBarController.viewControllers = [naviHeroVC, naviComicsVC, naviAuthorVC]
		return tabBarController
	}

	func getDetailModule(hero: ResultChar) -> DetailViewController {
		let repository = ComicsRepository()
		let presenter = DetailPresenter(hero: hero, repository: repository)
		let viewController = DetailViewController(presenter: presenter)
		presenter.detailVC = viewController
		presenter.getComics()
		return viewController
	}

	func getHeroModule() -> HeroViewController {
		let repository = HeroesRepository()
		let router = HeroRouter(factory: self)
		let presenter = HeroPresenter(repository: repository, router: router)
		let viewController = HeroViewController(presenter: presenter)
		router.viewController = viewController
		presenter.heroVC = viewController
		return viewController
	}
}
