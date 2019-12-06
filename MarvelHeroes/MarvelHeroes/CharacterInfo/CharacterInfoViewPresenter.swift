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
	func getCharacter() -> Character
	func getImage()
	func getComicsCount() -> Int
	func getComics(by index: Int) -> Comic?
	func getComicsImage(for characterImage: Image, by indexPath: IndexPath)
}
final class CharacterInfoPresenter: ICharacterInfoPresenter
{
	private let router: ICharacterInfoRouter
	private let repository: IRepository
	private weak var view: CharacterInfoViewController?
	private let character: Character
	private var comics = [Comic]()

	init(router: ICharacterInfoRouter,
		 repository: IRepository,
		 view: CharacterInfoViewController,
		 character: Character) {
		self.router = router
		self.repository = repository
		self.view = view
		self.character = character
		loadComics()
	}

	func getCharacter() -> Character {
		return character
	}
	func getImage() {
		guard let thumbnail = character.thumbnail else { return }
		repository.loadCharacterImage(for: thumbnail, size: ImageSize.large) { result in
			switch result {
			case .success(let result):
				DispatchQueue.main.async {
					self.view?.characterImage.image = result
				}
			case .failure(let message):
				print(message)
			}
		}
	}
	private func loadComics() {
		guard let id = character.id else { return }
		DispatchQueue.main.async {
			self.view?.showLoadingIndicator()
		}
		repository.loadComics(by: id) { result in
			DispatchQueue.main.async {
				self.view?.hideLoadingIndicator()
			}
			switch result {
			case .success(let result):
				self.comics = result ?? []
				DispatchQueue.main.async {
					self.view?.comicsTableView.reloadData()
				}
			case .failure(let message):
				print(message)
			}
		}
	}
	func getComicsCount() -> Int {
		return comics.count
	}
	func getComics(by index: Int) -> Comic? {
		guard index < comics.count else { return nil }
		return comics[index]
	}
	func getComicsImage(for comicsImage: Image, by indexPath: IndexPath) {
		repository.loadCharacterImage(for: comicsImage, size: ImageSize.small) { comic in
			switch comic {
			case .success(let result):
				DispatchQueue.main.async {
					guard let cell = self.view?.comicsTableView.cellForRow(at: indexPath) as? ComicsTableViewCell else { return }
					cell.comicCover.image = result
					cell.layoutSubviews()
				}
			case .failure(let message):
				print(message)
			}
		}
	}
}
