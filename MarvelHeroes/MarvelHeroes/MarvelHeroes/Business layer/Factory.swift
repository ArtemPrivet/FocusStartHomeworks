//
//  Factory.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

class ModulesFactory {

	func getCharacterListModule(withRepository repository: ICharactersRepository & IImagesRepository) -> CharacterListViewController {

		let router = CharactersRouter(factory: self)
		let presenter = CharactersPresenter(repository: repository, router: router)
		let viewController = CharacterListViewController(presenter: presenter)
		router.view = viewController
		presenter.view = viewController

		return viewController
	}

//	func getDetailContactModule(contact: Contact) -> DetailContactViewController {
//		let presenter = DetailContactPresenter(contact: contact)
//		let viewController = DetailContactViewController(presenter: presenter)
//		return viewController
//	}
}
