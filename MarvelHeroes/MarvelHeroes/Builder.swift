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
final class Builder: IBuilder
{
	private let remoteDataService = RemoteDataService()

	func createCharactersViewController() -> CharactersViewController {
		let remoteDataService = self.remoteDataService
		let repository = Repository(remoteDataService: remoteDataService)
		let view = CharactersViewController()
		let router = CharactersRouter(builder: self, view: view)
		let presenter = CharactersPresenter(router: router,
										repository: repository,
										view: view )
		view.presenter = presenter
		return view
	}
	func createCharacterInfoViewController(character: Character) -> CharacterInfoViewController {
		let remoteDataService = self.remoteDataService
		let repository = Repository(remoteDataService: remoteDataService)
		let view = CharacterInfoViewController()
		let router = CharacterInfoRouter(builder: self, view: view)
		let presenter = CharacterInfoPresenter(router: router,
											   repository: repository,
											   view: view,
											   character: character)
		view.presenter = presenter
		return view
	}
}
