//
//  DetailsComicsPresenter.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IDetailsComicsPresenter
{
	func getComics() -> Comic
	func getCharactersCount() -> Int
	func getCharacter(index: Int) -> Character
	func getCharacterImage(index: Int)
	func setupView()
	func setupBackgroungImage()
}

final class DetailsComicsPresenter
{
	weak var detailsView: DetailsComicsViewController?
	private let comics: Comic
	private let repository: ICharactersRepository
	private var characters: [Character] = []
	private let loadCharactersQueue = DispatchQueue(label: "loadCharactersQueue",
													qos: .userInteractive,
													attributes: .concurrent)

	init(comics: Comic, repository: ICharactersRepository) {
		self.comics = comics
		self.repository = repository
		setupView()
		setupBackgroungImage()
	}
}

extension DetailsComicsPresenter: IDetailsComicsPresenter
{
	func setupBackgroungImage() {
		self.repository.dataRepository.loadImage(urlString:
			String.getUrlString(image: comics.thumbnail, variant: ThumbnailVarians.standardFantastic))
		{ imageResult in
			switch imageResult {
			case .success(let image):
				DispatchQueue.main.async {
					self.detailsView?.setBackgroundImageView(image: image)
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
		repository.loadCharacters(fromPastScree: .comics,
								  with: comics.id,
								  searchResult: nil) { [weak self] charactersResult in
			guard let self = self else { return }
			switch charactersResult {
			case .success(let loadedData):
				self.characters = loadedData.data.results
				DispatchQueue.main.async {
					self.detailsView?.stopActivityIndicator()
					self.detailsView?.updateData()
				}
			case .failure(let error):
				DispatchQueue.main.async {
					self.detailsView?.stopActivityIndicator()
					self.detailsView?.showAlert(error: error)
				}
			}
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
						self.detailsView?.updateTableViewCell(index: index, image: image)
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
