//
//  CharctersPresenter.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol ICharacterPresenter
{
	func getCharactersCount() -> Int
	func getCharacter(index: Int) -> Character
	func getCharacterImage(index: Int)
	func showDetailCharacter(index: Int)
	func setupView(with search: String?)
}

final class CharactersPresenter
{
	weak var charactersView: CharactersViewController?
	private let repository: ICharactersRepository
	private let router: ICharactersRouter
	private var characters: [Character] = []
	private let loadCharactersQueue = DispatchQueue(label: "loadCharactersQueue",
													qos: .userInteractive,
													attributes: .concurrent)

	init(repository: ICharactersRepository, router: ICharactersRouter) {
		self.repository = repository
		self.router = router
		setupView(with: nil)
	}
}

extension CharactersPresenter: ICharacterPresenter
{
	func getCharactersCount() -> Int {
		return characters.count
	}

	func getCharacter(index: Int) -> Character {
		return characters[index]
	}

	func showDetailCharacter(index: Int) {
		router.showDetails(character: characters[index])
	}

	func setupView(with search: String?) {
		loadCharactersQueue.async { [weak self] in
			guard let self = self else { return }
			self.repository.loadCharacters(fromPastScree: .none,
										   with: nil,
										   searchResult: search,
										   { [weak self] charactersResult in
				guard let self = self else { return }
				switch charactersResult {
				case .success(let loadedData):
					self.characters = loadedData.data.results
					DispatchQueue.main.async {
						self.charactersView?.updateData()
						self.charactersView?.stopActivityIndicator()
						self.charactersView?.checkRequestResult(isEmpty: loadedData.data.results.isEmpty)
					}
				case .failure(let error):
					DispatchQueue.main.async {
						self.charactersView?.stopActivityIndicator()
						self.charactersView?.showAlert(error: error)
					}
					print(error.localizedDescription)
				}
			})
		}
	}

	func getCharacterImage(index: Int) {
		loadCharactersQueue.async { [weak self] in
			guard let self = self else { return }
			let character = self.characters[index]
			self.repository.dataRepository.loadImage(urlString:
				String.getUrlString(image: character.thumbnail, variant: ThumbnailVarians.standardMedium))
			{ imageResult in
				switch imageResult {
				case .success(let image):
					DispatchQueue.main.async {
						self.charactersView?.updateTableViewCell(index: index, image: image)
					}
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}
	}
}
