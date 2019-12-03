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
	func setupView()
	func setupBackgroungImage() -> UIImage
}

class DetailsCharacterPresenter {
	weak var detailsView: DetailsCharacterViewController?
	var character: Character
	var repository: Repository
	var comicses: [Comic] = []
	let serialQueue = DispatchQueue(label: "loadComicsQueue")
	
	
	init(character: Character, repository: Repository) {
		self.character = character
		self.repository = repository
		setupView()
		setupBackgroungImage()
	}
	deinit {
		print("DetailsPresenter deinit")
	}
}

extension DetailsCharacterPresenter: IDetailsCharacterPresenter {
	func setupBackgroungImage() -> UIImage {
			self.repository.loadImage(urlString:
				String.getUrlString(image: character.thumbnail, variant: ThumbnailVarians.standardFantastic))
			{ imageResult in
				switch imageResult {
				case .success(let image):
					DispatchQueue.main.async {
						self.detailsView?.backgroundImageView.image = image
//						self.detailsView?.view.layoutSubviews()
					}
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		return UIImage()
	}
	
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
					self.detailsView?.updateData()
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		})
	}
	
	func getComicsImage(index: Int) -> UIImage {
		var resultImage = UIImage()
		serialQueue.async { [weak self] in
			guard let self = self else { return }
			let comics = self.comicses[index]
			self.repository.loadImage(urlString:
				String.getUrlString(image: comics.thumbnail, variant: ThumbnailVarians.standardMedium))
			{ imageResult in
				switch imageResult {
				case .success(let image):
					DispatchQueue.main.async {
						guard let cell = self.detailsView?.comicsTableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
						cell.imageView?.image = image
						cell.layoutSubviews()
					}
					resultImage = image
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}
		return resultImage
	}
	
	func getCharacter() -> Character {
		return character
	}
}
