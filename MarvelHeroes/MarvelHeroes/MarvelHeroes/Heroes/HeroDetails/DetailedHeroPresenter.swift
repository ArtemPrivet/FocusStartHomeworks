//
//  DetailedHeroPresenter.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 07/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import UIKit

protocol IComicsDelegate: AnyObject
{
	func showComics(comics: [Comics])
	func showHeroImage(_ image: UIImage)
	func showComicsImage(_ image: UIImage, index: Int)
	//func updateCellImage(index: Int, image: UIImage)
}

protocol IDetailedHeroPresenter
{
	func getCharacter() -> Character
	func getComics(for hero: Character)
	func getImage(index: Int)
	func getComicsImage(index: Int)

	var delegate: IComicsDelegate? { get set }
}

final class DetailedHeroPresenter
{
	private var character: Character
	private var repository: Repository
	weak var delegate: IComicsDelegate?
	private let comicsQueue = DispatchQueue(label: "comicsQueue",
											qos: .userInteractive,
											attributes: .concurrent)
	private var comics: [Comics] = []

	init(character: Character, repository: Repository) {
		self.character = character
		self.repository = repository
	}

	private func createUrl(_ hero: Character) -> URL? {
		let urlString = "\(Urls.baseUrl)\(Urls.chracterEndpoint)/\(hero.id)/\(Urls.comicsEndpoint)"
		var components = URLComponents(string: urlString)
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "title"),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		return components?.url
	}
}

extension DetailedHeroPresenter: IDetailedHeroPresenter
{
	func getCharacter() -> Character {
		return character
	}

	func getComics(for hero: Character) {
		comicsQueue.async { [weak self] in
			guard let self = self else { return }
			guard let url = self.createUrl(hero) else { return }
			self.repository.loadComics(called: hero.name,
									   url: url,
									   { [weak self] comicsResult in
										guard let self = self else { return }
										switch comicsResult {
										case .success(let data):
											self.comics = data.data.results
											DispatchQueue.main.async {
												self.delegate?.showComics(comics: data.data.results)
											}
										case .failure(let error):
											print(error.localizedDescription)
										}
			})
		}
	}

	func getImage(index: Int) {
		comicsQueue.async { [weak self] in
			guard let self = self else { return }
			self.repository.loadImage(hero: self.character, quality: "standard_fantastic",
									  { imageResult in
										switch imageResult {
										case .success(let image):
											DispatchQueue.main.async {
												self.delegate?.showHeroImage(image)
											}
										case .failure(let error):
											print(error.localizedDescription)
										}
			})
		}
	}

	func getComicsImage(index: Int) {
		comicsQueue.async { [weak self] in
			guard let self = self else { return }
			self.repository.loadComicsImage(comics: self.comics[index],
											quality: "standard_medium",
											{ imageResult in
												switch imageResult {
												case .success(let image):
													DispatchQueue.main.async {
														self.delegate?.showComicsImage(image, index: index)
													}
												case .failure(let error):
													print(error.localizedDescription)
												}
			})
		}
	}
}
