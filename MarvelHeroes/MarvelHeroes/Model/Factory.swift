//
//  Factory.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

class Factory {
	//create characters module
	func createCharactersModule() -> CharactersViewController {
		let repository = Repository()
		let charactersRouter = CharactersRouter(factory: self)
		let charactersPresenter = CharactersPresenter(repository: repository, router: charactersRouter)
		let charactersView = CharactersViewController(presenter: charactersPresenter)
		charactersPresenter.charactersView = charactersView
		charactersRouter.charactersView = charactersView
		return charactersView
	}
	
	//create details characters module
	func createDetailsVC(chracter: Character) -> DetailsCharacterViewController {
		let repository = Repository()
		let detailsPresenter = DetailsCharacterPresenter(character: chracter, repository: repository)
		let detailsVC = DetailsCharacterViewController(presenter: detailsPresenter)
		detailsPresenter.detailsView = detailsVC
		return detailsVC
	}
	
	//create comics module
	func createComicsModule() -> ComicsViewController {
		let repository = Repository()
		let comicsRouter = ComicsRouter(factory: self)
		let comicsPresenter = ComicsPresenter(repository: repository, router: comicsRouter)
		let comicsView = ComicsViewController(presenter: comicsPresenter)
		comicsPresenter.comicsView = comicsView
		comicsRouter.comicsView = comicsView
		return comicsView
	}
	
	//create details comics module
	func createDetailsVC(comics: Comic) -> DetailsComicsViewController {
		let repository = Repository()
		let detailsPresenter = DetailsComicsPresenter(comics: comics, repository: repository)
		let detailsVC = DetailsComicsViewController(presenter: detailsPresenter)
		detailsPresenter.detailsView = detailsVC
		return detailsVC
	}
	
	//create authors module
	func createAuthorsModule() -> AuthorsViewController {
		let repository = Repository()
		let authorsRouter = AuthorRouter(factory: self)
		let authorsPresenter = AuthorsPresenter(repository: repository, router: authorsRouter)
		let authorsView = AuthorsViewController(presenter: authorsPresenter)
		authorsPresenter.authorView = authorsView
		authorsRouter.authorView = authorsView
		return authorsView
	}

}
