//
//  CharacterInfoViewPresenter.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 05.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import UIKit
protocol ICharacterInfoPresenter
{
	var comicsCount: Int { get }

	func loadComics()
	func getCharacter() -> Character
	func loadCharacterImage()
	func getComics(by index: Int) -> Comic?
	func getComicsImage(for characterImage: Image, by index: Int)
}
final class CharacterInfoPresenter: ICharacterInfoPresenter
{
	private let router: ICharacterInfoRouter
	private let repository: IRepository
	internal var view: CharacterInfoViewController?
	private let character: Character
	private var comics = [Comic]()
	var comicsCount: Int {
		return comics.count
	}

	init(router: ICharacterInfoRouter,
		 repository: IRepository,
		 character: Character) {
		self.router = router
		self.repository = repository
		self.character = character
		loadComics()
	}

	func getCharacter() -> Character {
		return character
	}
	func loadCharacterImage() {
		guard let thumbnail = character.thumbnail else { return }
		repository.loadCharacterImage(for: thumbnail, size: ImageSize.large) { result in
			switch result {
			case .success(let result):
				DispatchQueue.main.async {
					self.view?.setCharacterImage(image: result)
				}
			case .failure(let message):
				print(message)
			}
		}
	}
	func loadComics() {
		guard let id = character.id else { return }
		self.view?.showLoadingIndicator()
		repository.loadComics(by: id) { [weak self] result in
			DispatchQueue.main.async {
				self?.view?.hideLoadingIndicator()
			}
			switch result {
			case .success(let result):
				self?.comics = result ?? []
				DispatchQueue.main.async {
					self?.view?.updateComicsTableView()
				}
			case .failure(let message):
				print(message)
			}
		}
	}
	func getComics(by index: Int) -> Comic? {
		guard index < comics.count else { return nil }
		return comics[index]
	}
	func getComicsImage(for comicsImage: Image, by index: Int) {
		repository.loadCharacterImage(for: comicsImage, size: ImageSize.small) { [weak self] comic in
			switch comic {
			case .success(let result):
				DispatchQueue.main.async {
					self?.view?.setComicsImage(image: result, for: index)
				}
			case .failure(let message):
				print(message)
			}
		}
	}
}
