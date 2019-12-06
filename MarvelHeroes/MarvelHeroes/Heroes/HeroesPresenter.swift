//
//  HeroesPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class HeroesPresenter
{
	var heroesRouter: IHeroesRouter
	var repository: IRepository
	weak var heroesView: IHeroesView?

	init(heroesRouter: IHeroesRouter, repository: IRepository) {
		self.heroesRouter = heroesRouter
		self.repository = repository
	}

	var heroesDataWrapper: HeroesDataWrapper?
	var imagesStringURL: [String] = []
	var imagesData: [Data] = []
	let dispatchGroup = DispatchGroup()
	let dispatchQueue = DispatchQueue(label: "loadHeroes", qos: .userInitiated)
}

extension HeroesPresenter: IHeroesPresenter
{
	func getHeroes(withHeroeName name: String?) {
		self.dispatchQueue.async {
			print("[---Start Heroes Module---]")
			self.loadHeroesImages(withHeroeName: name)
			self.dispatchGroup.notify(queue: .main) {
				print("| 3.1) Reload")
				print("[----End Heroes Module----]")
				self.heroesView?.reloadData(withHeroesCount: self.getHeroesCount())
			}
		}
	}

	func getHeroesCount() -> Int {
		return self.heroesDataWrapper?.data?.results?.count ?? 0
	}

	func getHeroe(at index: Int) -> Heroe? {
		let character = self.heroesDataWrapper?.data?.results?[index]
		return character
	}

	func getHeroeImageData(at index: Int) -> Data {
		return self.imagesData[index]
	}

	func onCellPressed(heroe: Heroe) {
		self.heroesRouter.pushModuleWithHeroeInfo(heroe: heroe)
	}
}

extension HeroesPresenter
{
	private func loadHeroesImages(withHeroeName name: String?) {
		self.dispatchGroup.enter()
		print("| 1.1) Loading heroes.")
		self.repository.getHeroes(withHeroeName: name) { [weak self] heroesResult in
			guard let self = self else { return }
			switch heroesResult {
			case .success(let heroesDataWrapper):
				self.heroesDataWrapper = heroesDataWrapper
				print("| 1.2) Heroes were loaded.")
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
			self.imagesStringURL.removeAll()
			self.imagesData.removeAll()
			self.dispatchGroup.leave()
		}
		self.dispatchGroup.wait()
		print("| 2.1) Loading images.")
		self.heroesDataWrapper?.data?.results?.forEach { [weak self] heroe in
			guard let self = self else { return }
			if let path = heroe.thumbnail?.path, let thumbnailExtension = heroe.thumbnail?.thumbnailExtension {
				self.imagesStringURL.append( path + ImageSize.medium + thumbnailExtension)
			}
		}
		self.imagesStringURL.forEach { [weak self] imageURLString in
			guard let self = self else { return }
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: imageURLString, { dataResult in
				switch dataResult {
				case .success(let data):
					if let data = data {
						self.imagesData.append(data)
					}
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			})
		}
		self.dispatchGroup.wait()
		print("| 2.2) Images were loaded.")
	}
}
