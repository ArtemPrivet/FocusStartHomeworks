//
//  DetailsCharacterPresenter.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IDetailsCharacterPresenter {
	func getCharacter() -> Character
	func getComicsCount() -> Int
	func getComics(index: Int) -> Comic
	func getComicsImage(index: Int) -> UIImage
//	func showDetailCharacter(index: Int)
	func setupView()
}

class DetailsCharacterPresenter {
	weak var detailsView: DetailsCharacterViewController?
	var character: Character
	var repository: Repository
	var comicses: [Comic] = []

	init(character: Character, repository: Repository) {
		self.character = character
		self.repository = repository
		setupView()
	}
	deinit {
		print("DetailsPresenter deinit")
	}
}

extension DetailsCharacterPresenter: IDetailsCharacterPresenter {
	func getComicsCount() -> Int {
		return comicses.count
	}
	
	func getComics(index: Int) -> Comic {
		return comicses[index]
	}
	
	func setupView() {
		print("setupView")
		repository.loadComics(characterId: character.id, { [weak self] comicsResult in
			guard let self = self else { return }
			switch comicsResult {
			case .success(let loadedData):
				self.comicses = loadedData.data.results
				DispatchQueue.main.async {
					self.detailsView?.comicsTableView.reloadData()
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		})
	}
	
	func getComicsImage(index: Int) -> UIImage {
		return UIImage()
	}
	
	func getCharacter() -> Character {
		return character
	}
}
