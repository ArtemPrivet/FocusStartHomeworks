//
//  HeroRouter.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/5/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

final class HeroRouter
{
	weak var viewController: HeroViewController?
	private let factory: ModulesFactory

	init(factory: ModulesFactory) {
		self.factory = factory
	}
}

extension HeroRouter: IHeroRouter
{
	func showDetail(with hero: ResultChar) {
		let detailViewController = factory.getDetailModule(hero: hero)
		detailViewController.view.backgroundColor = .white
		viewController?.navigationController?.pushViewController(detailViewController, animated: true)
	}
}
