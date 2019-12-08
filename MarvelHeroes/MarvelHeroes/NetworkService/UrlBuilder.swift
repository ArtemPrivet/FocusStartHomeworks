//
//  UrlBuilder.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 08.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

final class UrlBuilder
{
	private let baseUrl = Urls.baseUrl
	private var pastScreenUrl = ""
	private var id = ""
	private var endUrl = ""

	@discardableResult
	func objectId(_ objectId: String?) -> Self {
		guard let objectId = objectId else { return self }
		id = objectId
		return self
	}

	@discardableResult
	func fromPastScreen(pastScreen: UrlPath) -> Self {
		switch pastScreen {
		case .characters:
			pastScreenUrl = "characters"
		case .authors:
			pastScreenUrl = "creators"
		case .comics:
			pastScreenUrl = "comics"
		case .none:
			break
		}
		return self
	}

	@discardableResult
	func endPath(object: UrlPath) -> Self {
		switch object {
		case .characters:
			endUrl = "characters"
		case .authors:
			endUrl = "creators"
		case .comics:
			endUrl = "comics"
		case .none:
			break
		}
		return self
	}

	func build() -> String {
		return "\(baseUrl)\(pastScreenUrl)/\(id)/\(endUrl)"
	}
}
