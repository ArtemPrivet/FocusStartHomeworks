// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct CharacterDataWrapper: Decodable
{
	let code: Int
	let status: String
	let copyright: String
	let attributionText: String
	let attributionHTML: String
	let data: CharacterDataContainer
	let etag: String
}

struct CharacterDataContainer: Decodable
{
	let offset: Int
	let limit: Int
	let total: Int
	let count: Int
	let results: [Character]
}

struct Character: Decodable
{
	let id: Int
	let name: String
	let description: String
	let modified: String
	let resourceURI: String
	let urls: [Url]
	let thumbnail: Image
	let comics: ComicList
	let stories: StoryList
	let events: EventList
	let series: SeriesList
}

struct Url: Decodable
{
	let type: String
	let url: String
}

struct Image: Decodable
{
	let path: String
	let `extension`: String
}

struct ComicList: Decodable
{
	let available: Int
	let returned: Int
	let collectionURI: String
	let items: [ComicSummary]
}

struct ComicSummary: Decodable
{
	let resourceURI: String
	let name: String
}

struct StoryList: Decodable
{
	let available: Int
	let returned: Int
	let collectionURI: String
	let items: [StorySummary]
}

struct StorySummary: Decodable
{
	let resourceURI: String
	let name: String
	let type: String
}
struct EventList: Decodable
{
	let available: Int
	let returned: Int
	let collectionURI: String
	let items: [EventSummary]
}

struct EventSummary: Decodable
{
	let resourceURI: String
	let name: String
}

struct SeriesList: Decodable
{
	let available: Int
	let returned: Int
	let collectionURI: String
	let items: [SeriesSummary]
}
struct SeriesSummary: Decodable
{
	let resourceURI: String
	let name: String
}
