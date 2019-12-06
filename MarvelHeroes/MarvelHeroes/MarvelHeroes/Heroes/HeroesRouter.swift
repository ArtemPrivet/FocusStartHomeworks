//
//  HeroesRouter.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 04/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation

protocol IHeroesRouter {
	//func showDetail(with contact: Hero)
}

class HeroesRouter {
	
	weak var viewController: HeroesViewController?
	
	private var factory: ModulesFactory
	
	init(factory: ModulesFactory) {
		self.factory = factory
	}
}

extension HeroesRouter: IHeroesRouter {
	
//	func showDetail(with contact: Hero) {
//		let detailViewController = factory.getDetailContactModule(contact: contact)
//		detailViewController.view.backgroundColor = .white
//		viewController?.navigationController?.pushViewController(detailViewController,
//																 animated: true)
//	}
}
