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
	var characterCount: Int { get }

	func loadCharacters()
	func getCharacter(by index: Int) -> Character?
	func showDetails(character: Character)
	func getCharacter(by characterName: String)
	func getCharacterImage(for characterImage: Image, by index: Int)
}
final class CharactersPresenter: ICharactersPresenter
{
	private let router: ICharactersRouter
	private let repository: IRepository
	var view: CharactersViewController?
	private var characters = [Character]()
	var characterCount: Int {
		return characters.count
	}

	init(router: ICharactersRouter, repository: IRepository) {
		self.router = router
		self.repository = repository
		loadCharacters()
	}
	func loadCharacters() {
		self.view?.showLoadingIndicator()
		self.view?.hideError()
		repository.loadCharacters { [weak self] characters in
			switch characters {
			case .success(let result):
				self?.characters = result ?? []
				DispatchQueue.main.async {
					self?.view?.hideLoadingIndicator()
					self?.view?.updateTableView()
				}
			case .failure(let message):
				DispatchQueue.main.async {
					self?.showAlert(error: message)
				}
			}
		}
	}
	func getCharacter(by index: Int) -> Character? {
		guard index < characters.count else { return nil }
		return characters[index]
	}
	func getCharacterImage(for characterImage: Image, by index: Int) {
		repository.loadCharacterImage(for: characterImage, size: ImageSize.small) { characters in
			switch characters {
			case .success(let result):
				DispatchQueue.main.async {
					self.view?.setImage(image: result, for: index)
				}
			case .failure(let message):
				DispatchQueue.main.async {
					self.showAlert(error: message)
				}
			}
		}
	}
	private func showAlert(error: ServiceError) {
		switch error {
		case .browserError:
			router.showAlert(title: "Error", message: "Client error", style: .alert)
		case .decodingError(let error):
			router.showAlert(title: "Error!", message: error.localizedDescription, style: .alert)
		case .invalidURL(let error):
			router.showAlert(title: "Error!", message: error.localizedDescription, style: .alert)
		default:
			break
		}
	}
	func getCharacter(by characterName: String) {
		loadCharacter(by: characterName)
	}
	private func loadCharacter(by characterName: String) {
		self.view?.showLoadingIndicator()
		self.view?.hideError()
		repository.loadCharacter(by: characterName) { character in
			DispatchQueue.main.async {
				self.view?.hideLoadingIndicator()
			}
			switch character {
			case .success(let result):
				self.characters = result ?? []
				DispatchQueue.main.async {
					if result?.isEmpty == true {
						self.view?.showError(with: characterName)
					}
					else {
						self.view?.hideError()
					}
					self.view?.updateTableView()
				}
			case .failure(let message):
				DispatchQueue.main.async {
					self.showAlert(error: message)
				}
			}
		}
	}
	func showDetails(character: Character) {
		router.showCharacterInfoViewController(character: character)
	}
}
