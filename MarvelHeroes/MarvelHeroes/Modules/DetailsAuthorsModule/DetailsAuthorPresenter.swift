//
//  DetailsAuthorPresenter.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IDetailsAuthorPresenter
{
	func getAuthor() -> Creator
	func getComicsesCount() -> Int
	func getComics(index: Int) -> Comic
	func getComicsImage(index: Int)
	func setupView()
	func setupBackgroungImage()
}

final class DetailsAuthorPresenter
{
	weak var detailsView: DetailsAuthorViewController?
	private let author: Creator
	private let repository: IComicsRepository
	private var comicses: [Comic] = []
	private let loadComicsesQueue = DispatchQueue(label: "loadComicsesQueue",
												  qos: .userInteractive,
												  attributes: .concurrent)

	init(author: Creator, repository: IComicsRepository) {
		self.author = author
		self.repository = repository
		setupView()
		setupBackgroungImage()
	}
}

extension DetailsAuthorPresenter: IDetailsAuthorPresenter
{
	func setupBackgroungImage() {
		self.repository.dataRepository.loadImage(urlString:
			String.getUrlString(image: author.thumbnail, variant: ThumbnailVarians.standardFantastic))
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

	func getComicsesCount() -> Int {
		return comicses.count
	}

	func getComics(index: Int) -> Comic {
		return comicses[index]
	}

	func setupView() {
		repository.loadComics(fromPastScreen: UrlPath.authors, with: author.id, searchResult: nil)
		{ [weak self] comicsesResult in
			guard let self = self else { return }
			switch comicsesResult {
			case .success(let loadedData):
				self.comicses = loadedData.data.results
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

	func getComicsImage(index: Int) {
		loadComicsesQueue.async { [weak self] in
			guard let self = self else { return }
			let comics = self.comicses[index]
			self.repository.dataRepository.loadImage(urlString:
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

	func getAuthor() -> Creator {
		return author
	}
}
