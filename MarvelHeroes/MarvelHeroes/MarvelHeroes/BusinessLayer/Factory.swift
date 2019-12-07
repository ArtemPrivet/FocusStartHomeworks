//
//  Factory.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 04.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation

class Factory {

	func getCharacterTableViewController() -> CharacterTableViewController {
		let repository = CharacterRepository()
		let router = CharacterRouter(factory: self)
		let presenter = CharacterPresenter(repository: repository, router: router)
		let viewController = CharacterTableViewController(presenter: presenter)
		router.viewController = viewController
		return viewController
	}
}
