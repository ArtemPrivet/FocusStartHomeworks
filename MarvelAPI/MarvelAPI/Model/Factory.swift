//
//  Factory.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

class Factory {
	func createCharactersModule() -> CharactersViewController {
		let repository = Repository()
		let charactersRouter = CharactersRouter(factory: self)
		let charactersPresenter = CharactersPresenter(repository: repository, router: charactersRouter)
		let charactersView = CharactersViewController(presenter: charactersPresenter)
		charactersPresenter.charactersView = charactersView
		charactersRouter.charactersView = charactersView
		return charactersView
	}
	
	func createDetailsVC(chracter: Character) -> DetailsCharacterViewController {
		let detailsPresenter = DetailsCharacterPresenter(character: chracter)
		let detailsVC = DetailsCharacterViewController(presenter: detailsPresenter)
		return detailsVC
	}
}
