//
//  HeroesPresenter.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 01.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation

protocol ICharactersPresenter
{
	func getCharacter(by index: Int) -> Character?
	func showDetails(character: Character)
	func getCharacter(by characterName: String)
	func getCharacterImage(for characterImage: Image, by indexPath: IndexPath)
	func getCharacterCount() -> Int
}
final class CharactersPresenter: ICharactersPresenter
{
	private let router: ICharactersRouter
	private let repository: IRepository
	private weak var view: CharactersViewController?
	private var characters = [Character]()

	init(router: ICharactersRouter, repository: IRepository, view: CharactersViewController) {
		self.router = router
		self.repository = repository
		self.view = view

		loadCharacters()
	}
	private func loadCharacters() {
		DispatchQueue.main.async {
			self.view?.showLoadingIndicator()
		}
		repository.loadCharacters { characters in
			DispatchQueue.main.async {
				self.view?.hideLoadingIndicator()
			}
			switch characters {
			case .success(let result):
				self.characters = result ?? []
				DispatchQueue.main.async {
					self.view?.tableView.reloadData()
				}
			case .failure(let message):
				print(message)
			}
		}
	}
	func getCharacter(by index: Int) -> Character? {
		guard index < characters.count else { return nil }
		return characters[index]
	}
	func getCharacterCount() -> Int {
		return characters.count
	}
	func getCharacterImage(for characterImage: Image, by indexPath: IndexPath) {
		repository.loadCharacterImage(for: characterImage, size: ImageSize.small) { characters in
			switch characters {
			case .success(let result):
				DispatchQueue.main.async {
					guard let cell = self.view?.tableView.cellForRow(at: indexPath) as? CharactersTableViewCell else { return }
					cell.characterImageView.image = result
					cell.layoutSubviews()
				}
			case .failure(let message):
				print(message)
			}
		}
	}
	func getCharacter(by characterName: String) {
		loadCharacter(by: characterName)
	}
	private func loadCharacter(by characterName: String) {
		DispatchQueue.main.async {
			self.view?.showLoadingIndicator()
			self.view?.hideError()
		}
		repository.loadCharacter(by: characterName) { character in
			DispatchQueue.main.async {
				self.view?.hideLoadingIndicator()
			}
			switch character {
			case .success(let result):
				if result?.isEmpty == true {
					DispatchQueue.main.async {
						self.view?.showError(with: characterName)
					}
				}
				else {
					DispatchQueue.main.async {
						self.view?.hideError()
					}
				}
				DispatchQueue.main.async {
					self.view?.tableView.reloadData()
				}
				self.characters = result ?? []
			case .failure(let message):
				print(message)
			}
		}
	}
	func showDetails(character: Character) {
		router.showCharacterInfoViewController(character: character)
	}
}
