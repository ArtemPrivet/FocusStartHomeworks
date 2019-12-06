//
//  HeroesPresenter.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 04/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import UIKit

protocol ITableViewDelegate
{
	func reloadTableView()
	func checkResultOfRequest(isEmpty: Bool)
	func updateCellImage(index: Int, image: UIImage)
}

protocol IHeroesPresenter
{
	func getCharactersCount() -> Int
	func getCharacters(_ called: String?)
	func getCharacter(_ id: Int) -> Character
	func getImage(index: Int)
	var delegate: ITableViewDelegate? { get set }
}

class HeroesPresenter {
	
	private var repository: IRepository
	private var router: IHeroesRouter
	private var characters: [Character] = []
	private let charactersQueue = DispatchQueue(label: "charactersQueue",
												qos: .userInteractive,
												attributes: .concurrent)
	var delegate: ITableViewDelegate?
	
	init(repository: IRepository, router: IHeroesRouter) {
		self.repository = repository
		self.router = router
	}
	
	private func createUrl(with name: String?) -> URL? {
		let urlString = "\(Urls.baseUrl)/\(Urls.chracterEndpoint)"
		
		var components = URLComponents(string: urlString)
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "name"),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		if let name = name {
			components?.queryItems?.append(URLQueryItem(name: "nameStartsWith", value: name))
		}
		return components?.url
	}
}

extension HeroesPresenter: IHeroesPresenter
{
	func getCharacter(_ id: Int) -> Character {
		return characters[id]
	}
	
	func getCharactersCount() -> Int {
		return characters.count
	}
	
	func getCharacters(_ called: String?) {
		charactersQueue.async { [weak self] in
			guard let self = self else { return }
			guard let url = self.createUrl(with: called) else { return }
			self.repository.loadCharacters(called: called, url: url, { [weak self] (charactersResult) in
				guard let self = self else { return }
				switch charactersResult {
				case .success(let data):
					self.characters = data.data.results
					DispatchQueue.main.async {
						self.delegate?.reloadTableView()
						self.delegate?.checkResultOfRequest(isEmpty: data.data.results.isEmpty)
					}
				case .failure(let error):
					print(error.localizedDescription)
				}
			})
		}
	}
	
	func getImage(index: Int) {
		charactersQueue.async { [weak self] in
			guard let self = self else { return }
			let character = self.characters[index]
			self.repository.loadImage(hero: character,
									  { imageResult in
										switch imageResult {
										case .success(let image):
											DispatchQueue.main.async {
												self.delegate?.updateCellImage(index: index, image: image)
											}
										case .failure(let error):
											print(error.localizedDescription)
										}
			})
		}
	}
}
