//
//  DetailsCharacterPresenter.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IDetailsCharacterPresenter
{
	func getCharacter() -> Character
	func getComicsCount() -> Int
	func getComics(index: Int) -> Comic
	func getComicsImage(index: Int)
	func setupView()
	func setupBackgroungImage()
	func showDetailAuthor(index: Int)
}

final class DetailsCharacterPresenter
{
	weak var detailsView: DetailsCharacterViewController?
	private let character: Character
	private let repository: IComicsRepository
	private let router: IDetailsCharacterRouter
	private var comicses: [Comic] = []
	private let loadComicsQueue = DispatchQueue(label: "loadComicsQueue",
												qos: .userInteractive,
												attributes: .concurrent)

	init(character: Character, repository: IComicsRepository & IDataRepository, router: IDetailsCharacterRouter) {
		self.character = character
		self.repository = repository
		self.router = router
		setupView()
		setupBackgroungImage()
	}
}

extension DetailsCharacterPresenter: IDetailsCharacterPresenter
{
	func showDetailAuthor(index: Int) {
//		router.showDetails(author: <#T##Creator#>)
	}

	func setupBackgroungImage() {
		self.repository.loadImage(urlString:
			String.getUrlString(image: character.thumbnail, variant: ThumbnailVarians.standardFantastic))
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

	func getComicsCount() -> Int {
		return comicses.count
	}

	func getComics(index: Int) -> Comic {
		return comicses[index]
	}

	func setupView() {
		repository.loadComics(fromPastScreen: UrlPath.characters,
							  with: character.id,
							  searchResult: nil,
							  { [weak self] comicsResult in
			guard let self = self else { return }
			switch comicsResult {
			case .success(let loadedData):
				self.comicses = loadedData.data.results
				DispatchQueue.main.async {
					self.detailsView?.updateData()
					self.detailsView?.stopActivityIndicator()
				}
			case .failure(let error):
				self.detailsView?.stopActivityIndicator()
				self.detailsView?.showAlert(error: error)
			}
		})
	}

	func getComicsImage(index: Int) {
		loadComicsQueue.async { [weak self] in
			guard let self = self else { return }
			let comics = self.comicses[index]
			self.repository.loadImage(urlString:
				String.getUrlString(image: comics.thumbnail, variant: ThumbnailVarians.standardMedium))
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

	func getCharacter() -> Character {
		return character
	}
}
