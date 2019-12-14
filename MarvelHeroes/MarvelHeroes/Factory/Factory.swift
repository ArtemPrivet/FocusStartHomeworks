//
//  Factory.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class Factory
{
	private let repository: IRepository

	init(repository: IRepository) {
		self.repository = repository
	}

	func createTabBarController() -> UITabBarController {
		let tabBarController = UITabBarController(nibName: nil, bundle: nil)
		return tabBarController
	}

	func createHeroesNavigationController() -> UINavigationController {
		let heroesNavigationController = UINavigationController(rootViewController: self.createHeroesModule())
		heroesNavigationController.navigationBar.prefersLargeTitles = true
		heroesNavigationController.tabBarItem = UITabBarItem(title: "Heroes", image: UIImage(named: "shield"), tag: 0)
		return heroesNavigationController
	}

	func createComicsNavigationController() -> UINavigationController {
		let comicsNavigationController = UINavigationController(rootViewController: self.createComicsModule())
		comicsNavigationController.tabBarItem = UITabBarItem(title: "Comics", image: UIImage(named: "comic"), tag: 1)
		comicsNavigationController.navigationBar.prefersLargeTitles = true
		return comicsNavigationController
	}

	func createAuthorsNavigationController() -> UINavigationController {
		let authorsNavigationController = UINavigationController(rootViewController: self.createAuthorsModule())
		authorsNavigationController.tabBarItem = UITabBarItem(title: "Authors",
															  image: UIImage(named: "writer"),
															  tag: 2)
		authorsNavigationController.navigationBar.prefersLargeTitles = true
		return authorsNavigationController
	}

	func createHeroesModule() -> UIViewController {
		let heroesRouter = HeroesRouter(factory: self)
		let heroesPresenter = HeroesPresenter(heroesRouter: heroesRouter, repository: self.repository)
		let heroesView = HeroesViewController(heroesPresenter: heroesPresenter)
		heroesRouter.heroesView = heroesView
		heroesPresenter.heroesView = heroesView
		return heroesView
	}

	func createHeroeDetailsModule(withHeroe heroe: Heroe) -> UIViewController {
		let heroeDetailsRouter = HeroeDetailsRouter(factory: self)
		let heroeDetailsPresenter = HeroeDetailsPresenter(heroeDetailsRouter: heroeDetailsRouter,
														  repository: self.repository,
														  heroe: heroe)
		let heroeDetailsView = HeroeDetailsViewController(heroeDetailsPresenter: heroeDetailsPresenter)
		heroeDetailsRouter.heroeDetailsView = heroeDetailsView
		heroeDetailsPresenter.heroeDetailsView = heroeDetailsView
		return heroeDetailsView
	}

	func createComicsModule() -> UIViewController {
		let comicsRouter = ComicsRouter(factory: self)
		let comicsPresenter = ComicsPresenter(comicsRouter: comicsRouter, repository: self.repository)
		let comicsView = ComicsViewController(comicsPresenter: comicsPresenter)
		comicsRouter.comicsView = comicsView
		comicsPresenter.comicsView = comicsView
		return comicsView
	}

	func createComicDetailsModule(withComic comic: Comic) -> UIViewController {
		let comicDetailsRouter = ComicDetailsRouter(factory: self)
		let comicDetailsPresenter = ComicDetailsPresenter(comicDetailsRouter: comicDetailsRouter,
														  repository: self.repository,
														  comic: comic)
		let comicDetailsView = ComicDetailsViewController(comicDetailsPresenter: comicDetailsPresenter)
		comicDetailsRouter.comicDetailsView = comicDetailsView
		comicDetailsPresenter.comicDetailsView = comicDetailsView
		return comicDetailsView
	}

	func createAuthorsModule() -> UIViewController {
		let authorsRouter = AuthorsRouter(factory: self)
		let authorsPresenter = AuthorsPresenter(authorsRouter: authorsRouter, repository: self.repository)
		let authorsView = AuthorsViewController(authorsPresenter: authorsPresenter)
		authorsRouter.authorsView = authorsView
		authorsPresenter.authorsView = authorsView
		return authorsView
	}

	func createAuthorDetailsModule(withAuthor author: Author) -> UIViewController {
		let authorDetailsRouter = AuthorDetailsRouter(factory: self)
		let authorDetailsPresenter = AuthorDetailsPresenter(authorDetailsRouter: authorDetailsRouter,
														  repository: self.repository,
														  author: author)
		let authorDetailsView = AuthorDetailsViewController(authorDetailsPresenter: authorDetailsPresenter)
		authorDetailsRouter.authorDetailsView = authorDetailsView
		authorDetailsPresenter.authorDetailsView = authorDetailsView
		return authorDetailsView
	}
}
