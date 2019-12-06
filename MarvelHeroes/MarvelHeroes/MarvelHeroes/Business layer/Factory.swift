//
//  Factory.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 04/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation

class ModulesFactory {
	
	func getHeroModule() -> HeroesViewController {
		let repository = Repository()
		let router = HeroesRouter(factory: self)
		let presenter = HeroesPresenter(repository: repository, router: router)
		let viewController = HeroesViewController(presenter: presenter)
		router.viewController = viewController
		return viewController
	}
	
//	func getDetailContactModule(contact: Contact) -> DetailContactViewController {
//		let presenter = DetailContactPresenter(contact: contact)
//		let viewController = DetailContactViewController(presenter: presenter)
//		return viewController
//	}
}
