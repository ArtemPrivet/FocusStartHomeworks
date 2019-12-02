//
//  CharacterDataWrapper.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import Foundation

// MARK: - CharacterDataWrapper
struct CharacterDataWrapper: Codable {
	let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
	var data: CharacterDataContainer
}

// MARK: - CharacterDataContainer
struct CharacterDataContainer: Codable {
	let offset, limit, total, count: Int
	let results: [Character]
}

// MARK: - Character
struct Character: Codable {
	//swiftlint:disable:next identifier_name
    let id: Int
	let name: String
	let resultDescription: String?
    let modified: Date
    let thumbnail: Thumbnail
    let resourceURI: String
	let comics: ComicList
	let series: SeriesList
    let stories: StoryList
    let events: EventList
    let urls: [URLElement]
}

extension CharacterDataWrapper {
	init(data: Data, decoder: JSONDecoder) throws {
		do {
			self = try decoder.decode(Self.self, from: data)
		} catch {
			throw error
		}
	}
}

//extension Array where Element == CharacterDataWrapper {
//	init(data: Data, decoder: JSONDecoder) throws {
//		do {
//			self = try decoder.decode(Self.self, from: data)
//		} catch {
//			throw error
//		}
//	}
//}
