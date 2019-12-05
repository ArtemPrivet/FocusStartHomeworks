//
//  DetailsComicsPresenter.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IDetailsComicsPresenter {
	func getComics() -> Comic
	func getCharactersCount() -> Int
	func getCharacter(index: Int) -> Character
	func getCharacterImage(index: Int)
	func setupView()
	func setupBackgroungImage()
}

class DetailsComicsPresenter {
	weak var detailsView: DetailsComicsViewController?
	var comics: Comic
	var repository: Repository
	var characters: [Character] = []
	let serialQueue = DispatchQueue(label: "loadCharactersQueue")
	
	
	init(comics: Comic, repository: Repository) {
		self.comics = comics
		self.repository = repository
		setupView()
		setupBackgroungImage()
	}
	deinit {
		print("DetailsComicsPresenter deinit")
	}
}

extension DetailsComicsPresenter: IDetailsComicsPresenter {
	func setupBackgroungImage() {
		self.repository.loadImage(urlString:
			String.getUrlString(image: comics.thumbnail, variant: ThumbnailVarians.standardFantastic))
		{ imageResult in
			switch imageResult {
			case .success(let image):
				DispatchQueue.main.async {
					self.detailsView?.backgroundImageView.image = image
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	func getCharactersCount() -> Int {
		return characters.count
	}
	
	func getCharacter(index: Int) -> Character {
		return characters[index]
	}
	
	func setupView() {
		repository.loadCharacters(with: comics.id, searchResult: nil) { [weak self] charactersResult in
			guard let self = self else { return }
			switch charactersResult {
			case .success(let loadedData):
				self.characters = loadedData.data.results
				DispatchQueue.main.async {
					self.detailsView?.activityIndicator.stopAnimating()
					self.detailsView?.updateData()
				}
			case .failure(let error):
				DispatchQueue.main.async {
					self.detailsView?.activityIndicator.stopAnimating()
				}
				print(error.localizedDescription)
			}
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
						guard let cell = self.detailsView?.charactersTableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
						cell.imageView?.image = image
						cell.layoutSubviews()
					}
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}

	}
	
	func getComics() -> Comic {
		return comics
	}
}
