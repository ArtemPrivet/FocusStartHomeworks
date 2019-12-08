//
//  AuthorsPresenter.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IAuthorsPresenter
{
	func getAuthorsCount() -> Int
	func getAuthor(index: Int) -> Creator
	func getAuthorImage(index: Int)
	func showDetailAuthor(index: Int)
	func setupView(with search: String?)
}

final class AuthorsPresenter
{
	weak var authorView: AuthorsViewController?
	private let repository: IAuthorsRepository
	private let router: IAuthorRouter
	private var authors: [Creator] = []
	private let loadAuthorsQueue = DispatchQueue(label: "loadAuthorsQueue",
												 qos: .userInteractive,
												 attributes: .concurrent)

	init(repository: IAuthorsRepository, router: IAuthorRouter) {
		self.repository = repository
		self.router = router
		setupView(with: nil)
	}
}

extension AuthorsPresenter: IAuthorsPresenter
{
	func getAuthorsCount() -> Int {
		return authors.count
	}

	func getAuthor(index: Int) -> Creator {
		return authors[index]
	}

	func showDetailAuthor(index: Int) {
		router.showDetails(author: authors[index])
	}

	func setupView(with search: String?) {
		loadAuthorsQueue.async { [weak self] in
			guard let self = self else { return }
			self.repository.loadAuthors(fromPastScreen: .none, with: nil, searchResult: search, { [weak self] authorsResult in
				guard let self = self else { return }
				switch authorsResult {
				case .success(let loadedData):
					self.authors = loadedData.data.results
					DispatchQueue.main.async {
						self.authorView?.updateData()
						self.authorView?.stopActivityIndicator()
						self.authorView?.checkRequestResult(isEmpty: loadedData.data.results.isEmpty)
					}
				case .failure(let error):
					DispatchQueue.main.async {
						self.authorView?.stopActivityIndicator()
						self.authorView?.showAlert(error: error)
					}
				}
			})
		}
	}

	func getAuthorImage(index: Int) {
		loadAuthorsQueue.async { [weak self] in
			guard let self = self else { return }
			let author = self.authors[index]
			self.repository.dataRepository.loadImage(urlString:
				String.getUrlString(image: author.thumbnail, variant: ThumbnailVarians.standardMedium))
			{ imageResult in
				switch imageResult {
				case .success(let image):
					DispatchQueue.main.async {
						self.authorView?.updateTableViewCell(index: index, image: image)
					}
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}
	}
}
