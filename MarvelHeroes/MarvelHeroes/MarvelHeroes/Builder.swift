//
//  Builder.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 01.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation

protocol IBuilder {
	func createHeroesViewController() -> HeroesViewController
}
final class Builder: IBuilder
{
	func createHeroesViewController() -> HeroesViewController {
		let router = HeroesRouter(builder: self)
		let remoteDataService = RemoteDataService()
		let repository = Repository(remoteDataService: remoteDataService)
		let heroesViewController = HeroesViewController()
		let presenter = HeroesPresenter(router: router,
										repository: repository,
										view: heroesViewController )
		heroesViewController.presenter = presenter
		return heroesViewController
	}


}
