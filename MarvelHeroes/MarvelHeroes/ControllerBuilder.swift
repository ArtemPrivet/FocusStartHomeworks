//
//  Builder.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 01.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation

protocol IBuilder
{
	func createCharactersViewController() -> CharactersViewController
	func createCharacterInfoViewController(character: Character) -> CharacterInfoViewController
}
final class ControllerBuilder: IBuilder
{
	private let remoteDataService = RemoteDataService()

	func createCharactersViewController() -> CharactersViewController {
		let remoteDataService = self.remoteDataService
		let repository = Repository(remoteDataService: remoteDataService)
		let router = CharactersRouter(builder: self)
		let presenter = CharactersPresenter(router: router,
										repository: repository)
		let view = CharactersViewController(presenter: presenter)
		router.view = view
		presenter.view = view
		return view
	}
	func createCharacterInfoViewController(character: Character) -> CharacterInfoViewController {
		let remoteDataService = self.remoteDataService
		let repository = Repository(remoteDataService: remoteDataService)
		let router = CharacterInfoRouter(builder: self)
		let presenter = CharacterInfoPresenter(router: router,
											   repository: repository,
											   character: character)
		let view = CharacterInfoViewController(presenter: presenter)
		router.view = view
		presenter.view = view
		return view
	}
}
