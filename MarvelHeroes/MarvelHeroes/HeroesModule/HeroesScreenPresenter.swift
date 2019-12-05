//
//  HeroesScreenPresenter.swift
//  MarvelHeroes
//
//  Created by Антон on 03.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import Foundation

protocol IMainScreenData
{
	func startLoading()
	func finishLoading()
	func setEmptyHeroes(characterName: String)
	func updateRow(indexPath: IndexPath)
}

final class HeroesScreenPresenter
{
	weak private var mainScreen: MainScreen?
	private (set) var heroesArray = [Character?]()
	var mainTitle: String {
		guard #available(iOS 12.0, *) else { return "Heroes" }
		return "🦸🏼‍♂️ Heroes"
	}

	deinit {
		print("Presenter deinit")
	}

	func attachMainScreen(_ mainScreen: MainScreen) {
		self.mainScreen = mainScreen
	}

	func getHero(_ indexPath: IndexPath) -> Character? {
		guard let hero = heroesArray[indexPath.row] else { return nil }
		return hero
	}

	func getHeroImageData(_ indexPath: IndexPath, callBack: @escaping (Data) -> Void) {
		guard let path = heroesArray[indexPath.row]?.thumbnail?.path else { return }
		guard let enlargement = heroesArray[indexPath.row]?.thumbnail?.enlargement else { return }
		let urlString = "\(path + "." + enlargement)"
		guard let url = URL(string: urlString) else { return }
		networkService.getHeroesImageData(url: url) { data in
			callBack(data)
			//self?.mainScreen?.updateRow(indexPath: indexPath)
		}
	}

	func resultsEmpty(characterName: String) {
		DispatchQueue.main.async {
			self.mainScreen?.setEmptyHeroes(characterName: characterName)
		}
	}

	let networkService: INetworkProtocol = NetworkService()

	func getData(characterName: String) {
		self.heroesArray.removeAll()
		self.mainScreen?.startLoading()
		self.networkService.getHeroes(charactersName: characterName) { [weak self] characterDataWrapper in
			guard let data = characterDataWrapper.data else { return }
			guard let result = data.results else { return }
			if result.isEmpty == true {
				self?.resultsEmpty(characterName: characterName)
				return
			}
			for hero in result {
				var modifiedHero = hero
				if modifiedHero.description == nil ||
					modifiedHero.description == " " ||
				modifiedHero.description?.isEmpty == true {
					modifiedHero.description = "No info"
				}
				self?.heroesArray.append(modifiedHero)
			}
			DispatchQueue.main.async {
				self?.mainScreen?.finishLoading()
			}
		}
	}
}
