//
//  HeroesPresenter.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 01.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation

protocol IHeroesPresenter {
	func getCharacters()
	func getCharacterImage(for characterImage: CharacterImage, by indexPath: IndexPath)
	func showData()
	
}
final class HeroesPresenter: IHeroesPresenter
{
	private let router: IHeroesRouter
	private let repository: IRepository
	private weak var view: HeroesViewController?

	init(router: IHeroesRouter, repository: IRepository, view: HeroesViewController) {
		self.router = router
		self.repository = repository
		self.view = view
	}
	func getCharacters() {
		repository.getCharacters { characters in
			switch characters {
			case .success(let result):
				self.view?.characters = result
				DispatchQueue.main.async {
					self.view?.tableView.reloadData()
				}
			case .failure(let message):
				print(message)
			}
		}
	}
	func getCharacterImage(for characterImage: CharacterImage, by indexPath: IndexPath) {
		repository.loadCharacterImage(for: characterImage) { characters in
			switch characters {
			case .success(let result):
				DispatchQueue.main.async {
					self.view?.tableView.cellForRow(at: indexPath)?.imageView?.image = result

				}
			case .failure(let message):
				print(message)
			}
		}
	}
	func showData() {
		
	}
}
