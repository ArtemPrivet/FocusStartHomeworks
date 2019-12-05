//
//  Protocols.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/5/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

protocol IDetailPresenter {
	func getHero() -> ResultChar
}

protocol IHeroPresenter {
	func getHero(of index: Int) -> ResultChar
	func getHeroes(of text: String)
	var heroesCount: Int { get }

	func showDetail(of index: Int)
}

protocol IHeroRouter {
	func showDetail(with hero: ResultChar)
}

protocol IHeroRepository {
	func getHeroes(_ text: String) -> [ResultChar]
}
