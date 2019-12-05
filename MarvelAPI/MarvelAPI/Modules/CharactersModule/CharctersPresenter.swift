//
//  CharctersPresenter.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol ICharacterPresenter {
	func getCharactersCount() -> Int
	func getCharacter(index: Int) -> Character
	func getCharacterImage(index: Int)
	func showDetailCharacter(index: Int)
	func setupView(with search: String?)
}

class CharactersPresenter {
	
	weak var charactersView: CharactersViewController?
	var repository: Repository
	var router: ICharactersRouter
	let serialQueue = DispatchQueue(label: "loadCharactersQueue", qos: .userInteractive)
	
	private var characters: [Character] = []
	private var charactersImage: [UIImage] = []

	init(repository: Repository, router: ICharactersRouter) {
		self.repository = repository
		self.router = router
		setupView(with: nil)
	}
}

extension CharactersPresenter: ICharacterPresenter {
	
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
		serialQueue.async { [weak self] in
			guard let self = self else { return }
			self.repository.loadCharacters(with: search, { [weak self] charactersResult in
				guard let self = self else { return }
				switch charactersResult {
				case .success(let loadedData):
					self.characters = loadedData.data.results
					DispatchQueue.main.async {
						self.charactersView?.updateData()
						self.charactersView?.checkRequestResult(isEmpty: loadedData.data.results.isEmpty)
					}
				case .failure(let error):
					print(error.localizedDescription)
				}
			})
		}
	}
	
	func getCharacterImage(index: Int) {
		serialQueue.async { [weak self] in
			guard let self = self else { return }
			let character = self.characters[index]
			self.repository.loadImage(urlString:
				String.getUrlString(image: character.thumbnail, variant: ThumbnailVarians.standardMedium))
			{ imageResult in
				switch imageResult {
				case .success(let image):
					DispatchQueue.main.async {
						guard let cell = self.charactersView?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
						cell.imageView?.image = image
						cell.layoutSubviews()
						cell.imageView?.clipsToBounds = true
						guard let imageView = cell.imageView else { return }
						cell.imageView?.layer.cornerRadius = imageView.bounds.width / 2
					}
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}
	}
}
