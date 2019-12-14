//
//  AuthorsPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class AuthorsPresenter
{
	private var authorsRouter: IAuthorsRouter
	private var repository: IRepository
	weak var authorsView: IAuthorsView?

	init(authorsRouter: IAuthorsRouter, repository: IRepository) {
		self.authorsRouter = authorsRouter
		self.repository = repository
	}

	private var authorsDataWrapper: AuthorsDataWrapper?
	private var authors: [AuthorViewItem] = []
	private let dispatchGroup = DispatchGroup()
	private let dispatchQueue = DispatchQueue(label: "loadAuthors", qos: .userInitiated)

	final private class AuthorViewItem
	{
		let imageUrl: String?
		var imageData: Data?

		init(imageUrl: String?, imageData: Data? = nil) {
			self.imageUrl = imageUrl
			self.imageData = imageData
		}
	}
}

extension AuthorsPresenter: IAuthorsPresenter
{
	func getAuthors(withAuthorName name: String?) {
		self.dispatchQueue.async {
			self.loadAuthorsImages(withAuthorName: name)
			self.dispatchGroup.notify(queue: .main) {
				self.authorsView?.reloadData(withAuthorsCount: self.getAuthorsCount())
			}
		}
	}
	func getAuthorsCount() -> Int {
		return self.authorsDataWrapper?.data?.results?.count ?? 0
	}
	func getAuthor(at index: Int) -> Author? {
		let author = self.authorsDataWrapper?.data?.results?[index]
		return author
	}
	func getAuthorImageData(at index: Int) -> Data? {
		return self.authors[index].imageData
	}
	func onCellPressed(author: Author) {
		self.authorsRouter.pushModuleWithAuthorInfo(author: author)
	}
}

private extension AuthorsPresenter
{
	private func loadAuthorsImages(withAuthorName name: String?) {
		self.dispatchGroup.enter()
		self.repository.getAuthors(withAuthorName: name) { [weak self] authorsResult in
			guard let self = self else { return }
			switch authorsResult {
			case .success(let authorsDataWrapper):
				self.authorsDataWrapper = authorsDataWrapper
				self.getImages()
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
			self.dispatchGroup.leave()
		}
		self.dispatchGroup.wait()
	}

	func getImages() {
		self.authors.removeAll()
		self.authorsDataWrapper?.data?.results?.forEach { author in
			if let path = author.thumbnail?.path, let thumbnailExtension = author.thumbnail?.thumbnailExtension {
				self.authors.append(AuthorViewItem(imageUrl: path + ImageSize.medium + thumbnailExtension))
			}
		}
		self.authors.forEach { author in
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: author.imageUrl ?? "", { [weak self] dataResult in
				guard let self = self else { return }
				switch dataResult {
				case .success(let data):
					if let data = data {
						author.imageData = data
					}
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			})
		}
	}
}
