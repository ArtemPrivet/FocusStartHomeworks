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
	func createHeroesModule() -> UIViewController {
		let repository = Repository()
		let heroesRouter = HeroesRouter(factory: self)
		let heroesPresenter = HeroesPresenter(heroesRouter: heroesRouter, repository: repository)
		let heroesView = HeroesView(heroesPresenter: heroesPresenter)
		heroesRouter.heroesView = heroesView
		heroesPresenter.heroesView = heroesView
		return heroesView
	}

	func createHeroeDetailsModule(withHeroe heroe: Heroe) -> UIViewController {
		let repository = Repository()
		let heroeDetailsRouter = HeroeDetailsRouter(factory: self)
		let heroeDetailsPresenter = HeroeDetailsPresenter(heroeDetailsRouter: heroeDetailsRouter,
														  repository: repository,
														  heroe: heroe)
		let heroeDetailsView = HeroeDetailsView(heroeDetailsPresenter: heroeDetailsPresenter)
		heroeDetailsRouter.heroeDetailsView = heroeDetailsView
		heroeDetailsPresenter.heroeDetailsView = heroeDetailsView
		return heroeDetailsView
	}

	func createComicsModule() -> UIViewController {
		let repository = Repository()
		let comicsRouter = ComicsRouter(factory: self)
		let comicsPresenter = ComicsPresenter(comicsRouter: comicsRouter, repository: repository)
		let comicsView = ComicsView(comicsPresenter: comicsPresenter)
		comicsRouter.comicsView = comicsView
		comicsPresenter.comicsView = comicsView
		return comicsView
	}

	func createComicDetailsModule(withComic comic: Comic) -> UIViewController {
		let repository = Repository()
		let comicDetailsRouter = ComicDetailsRouter(factory: self)
		let comicDetailsPresenter = ComicDetailsPresenter(comicDetailsRouter: comicDetailsRouter,
														  repository: repository,
														  comic: comic)
		let comicDetailsView = ComicDetailsView(comicDetailsPresenter: comicDetailsPresenter)
		comicDetailsRouter.comicDetailsView = comicDetailsView
		comicDetailsPresenter.comicDetailsView = comicDetailsView
		return comicDetailsView
	}

	func createAuthorsModule() -> UIViewController {
		let repository = Repository()
		let authorsRouter = AuthorsRouter(factory: self)
		let authorsPresenter = AuthorsPresenter(authorsRouter: authorsRouter, repository: repository)
		let authorsView = AuthorsView(authorsPresenter: authorsPresenter)
		authorsRouter.authorsView = authorsView
		authorsPresenter.authorsView = authorsView
		return authorsView
	}

	func createAuthorDetailsModule(withAuthor author: Author) -> UIViewController {
		let repository = Repository()
		let authorDetailsRouter = AuthorDetailsRouter(factory: self)
		let authorDetailsPresenter = AuthorDetailsPresenter(authorDetailsRouter: authorDetailsRouter,
														  repository: repository,
														  author: author)
		let authorDetailsView = AuthorDetailsView(authorDetailsPresenter: authorDetailsPresenter)
		authorDetailsRouter.authorDetailsView = authorDetailsView
		authorDetailsPresenter.authorDetailsView = authorDetailsView
		return authorDetailsView
	}
}
