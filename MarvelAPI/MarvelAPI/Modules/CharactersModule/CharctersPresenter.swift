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
	func getCharacterImage(index: Int) -> UIImage
	func showDetailCharacter(index: Int)
	func setupView()
}

class CharactersPresenter {
	
	weak var charactersView: ICharactersViewController?
	var repository: Repository
	var router: ICharactersRouter
	private let dispatchGroup = DispatchGroup()
	
	private var characters: [Character] = []
	private var charactersImage: [UIImage] = []

	init(repository: Repository, router: ICharactersRouter) {
		self.repository = repository
		self.router = router
		setupView()
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
	
	
	func setupView() {
		print("setupView")
		dispatchGroup.enter()
		repository.loadCharacters { [weak self] charactersResult in
			guard let self = self else { return }
			switch charactersResult {
			case .success(let loadedData):
				self.characters = loadedData.data.results
				DispatchQueue.main.async {
					self.charactersView?.updateData()
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
			self.dispatchGroup.leave()
		}
	}
	
	func getCharacterImage(index: Int) -> UIImage {
		dispatchGroup.enter()
		var resultImage = UIImage()
		let character = characters[index]
		repository.loadCharcterImage(urlString:
			String.getUrlString(character: character, variant: ThumbnailVarians.landspaceSmall))
		{ imageResult in
			switch imageResult {
			case .success(let image):
				resultImage = image
			case .failure(let error):
				print(error.localizedDescription)
			}
			self.dispatchGroup.leave()
		}
		return resultImage
	}
}
