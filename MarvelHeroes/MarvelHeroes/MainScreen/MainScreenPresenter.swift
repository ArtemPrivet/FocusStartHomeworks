//
//  TestPresenter.swift
//  MarvelHeroes
//
//  Created by Антон on 07.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//
protocol IMainScreen
{
	func startLoading()
	func finishLoading()
	func setEmptyResult(text: String)
}

import Foundation
final class MainScreenPresenter
{

	private let router = Router()
	private let networkService = NetworkService()
	weak var viewController: MainScreenViewController?
	private var modelArray = [StructForPresenterArray]()
	private let presenterType: PresenterType
	private var heroes: CharacterDataWrapper? {
		didSet {
			guard let data = heroes?.data else { return }
			guard let result = data.results else { return }
			guard result.isEmpty != true else { return }
			for model in result {
				var modifiedModel = model
				if modifiedModel.description == nil ||
				modifiedModel.description == " " ||
				modifiedModel.description?.isEmpty == true {
					modifiedModel.description = "No info"
				}
				let text = model.name
				let detailText = modifiedModel.description
				guard let path = model.thumbnail?.path else { return }
				guard let enlargement = model.thumbnail?.enlargement else { return }
				guard let url = URL(string: path + "." + enlargement) else { return }
				let id = modifiedModel.id
				let modelStructForPresenterArray = StructForPresenterArray(text: text,
																		   detailText: detailText,
																		   imageURL: url,
																		   id: id)
				modelArray.append(modelStructForPresenterArray)
			}
			DispatchQueue.main.async {
				self.viewController?.finishLoading()
			}
		}
	}
	private var series: SeriesDataWrapper? {
		didSet {
			self.modelArray.removeAll()
			guard let results = series?.data?.results else { return }
			for element in results {
				guard let id = element.id else { continue }
				guard let title = element.title else { continue }
				guard let description = element.description else { continue }
				guard let path = element.thumbnail?.path else { continue }
				guard let enlargement = element.thumbnail?.enlargement else { continue }
				guard let url = URL(string: path + "." + enlargement) else { continue }
				let model = StructForPresenterArray(text: title, detailText: description, imageURL: url, id: id)
				modelArray.append(model)
			}
			DispatchQueue.main.async {
				self.viewController?.finishLoading()
			}
		}
	}
	private var creators: CreatorDataWrapper? {
		didSet {
			self.modelArray.removeAll()
			guard let results = creators?.data?.results else { return }
			for element in results {
				guard let id = element.id else { continue }
				guard let fullName = element.fullName else { continue }
				guard let path = element.thumbnail?.path else { continue }
				guard let enlargement = element.thumbnail?.enlargement else { continue }
				guard let url = URL(string: path + "." + enlargement) else { continue }
				let model = StructForPresenterArray(text: fullName, detailText: nil, imageURL: url, id: id)
				modelArray.append(model)
			}
			DispatchQueue.main.async {
				self.viewController?.finishLoading()
			}
		}
	}

	init(presenterType: PresenterType) {
		self.presenterType = presenterType
	}

	private func checkArrayModelCount(text: String) {
		if self.modelArray.isEmpty == true {
			let errorText = self.createErrorText(text: text)
			DispatchQueue.main.async {
				self.viewController?.setEmptyResult(text: errorText)
			}
		}
	}

	private func createErrorText(text: String) -> String {
		let text = "Nothing found on query" + " " + text
		return text
	}
}
extension MainScreenPresenter: IMainScreenPresenter
{
	func getTitle() -> String {
		switch self.presenterType {
		case .heroScreen:
			guard #available(iOS 12.0, *) else { return "Heroes" }
			return "🦸🏼‍♂️ Heroes"
		case .authorsScreen:
			guard #available(iOS 12.0, *) else { return "Authors" }
			return "🧑🏼‍💻Authors"
		case .comicsScreen:
			guard #available(iOS 12.0, *) else { return "Comics" }
			return "📚Comics"
		default:
			return ""
		}
	}

	func getRowsCount() -> Int {
		return modelArray.count
	}

	func getTextLabelForCell(at indexPath: IndexPath) -> String {
		guard let text = modelArray[indexPath.row].text else { return "" }
		return text
	}

	func getDetailTextLabelForCell(at indexPath: IndexPath) -> String {
		guard let detailText = modelArray[indexPath.row].detailText else { return "No info" }
		return detailText
	}

	func getData(text: String) {
		self.modelArray.removeAll()
		self.viewController?.startLoading()
		switch self.presenterType {
		case .heroScreen:
			networkService.getHeroes(charactersName: text, callBack: { characterResult in
				do {
					self.heroes = try characterResult.get()
					self.checkArrayModelCount(text: text)
				}
				catch {
					assert(true, error.localizedDescription)
					DispatchQueue.main.async {
						self.viewController?.setEmptyResult(text: error.localizedDescription)
					}
				}
			})
		case .comicsScreen:
			networkService.getComicsAtNameStartsWith(string: text, callBack: { seriesResult in
				do {
					self.series = try seriesResult.get()
					self.checkArrayModelCount(text: text)
				}
				catch {
					assert(true, error.localizedDescription)
					DispatchQueue.main.async {
						self.viewController?.setEmptyResult(text: error.localizedDescription)
					}
				}
			})
		case .authorsScreen:
			networkService.getAuthorsAtNameStartsWith(string: text, callBack: { creatorsResult in
				do {
					self.creators = try creatorsResult.get()
					self.checkArrayModelCount(text: text)
				}
				catch {
					assert(true, error.localizedDescription)
					DispatchQueue.main.async {
						self.viewController?.setEmptyResult(text: error.localizedDescription)
					}
				}
			})
		default:
		break
		}
	}

	func getImageDataForCell(at indexPath: IndexPath, callBack: @escaping (Data) -> Void) {
		guard let url = modelArray[indexPath.row].imageURL else { return }
		networkService.getImageData(url: url) { data in
			DispatchQueue.main.async {
				callBack(data)
			}
		}
	}

	func getPlaceholderFromSearchBar() -> String {
		return "Enter the name of hero"
	}

	func attachViewController(viewController: MainScreenViewController) {
		self.viewController = viewController
	}

	func showDetail(at indexPath: IndexPath) {
		let model = self.modelArray[indexPath.row]
		switch self.presenterType {
		case .heroScreen:
			router.mainViewController = viewController
			router.showDetail(model: model, presenterType: .heroScreenDetail)
		case .comicsScreen:
			router.mainViewController = viewController
			router.showDetail(model: model, presenterType: .comicsScreenDetail)
		case .authorsScreen:
			router.mainViewController = viewController
			router.showDetail(model: model, presenterType: .authorsScreenDetail)
		default:
			break
		}
	}
}
