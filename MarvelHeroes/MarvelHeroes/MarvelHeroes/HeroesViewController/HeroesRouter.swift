//
//  HeroesRouter.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 01.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation

protocol IHeroesRouter {
	func showViewController()
	
}
final class HeroesRouter: IHeroesRouter
{
	weak var viewController: HeroesViewController?
	private let builder: IBuilder

	init(builder: IBuilder){
		self.builder = builder
	}
	func showViewController() {
		
	}

}
