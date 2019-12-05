//
//  Lists.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

// MARK: - SeriesList
struct SeriesList: Codable
{
	let available: Int
	let collectionURI: String
	let items: [SeriesSummary]
	let returned: Int
}

// MARK: SeriesSummary
struct SeriesSummary: Codable
{
	let resourceURI: String
	let name: String
}

// MARK: - ComicList
struct ComicList: Codable
{
	let available: Int
	let collectionURI: String
	let items: [ComicSummary]
	let returned: Int
}

// MARK: ComicSummary
struct ComicSummary: Codable
{
	let resourceURI: String
	let name: String
}

// MARK: - StoryList
struct StoryList: Codable
{
	let available: Int
	let collectionURI: String
	let items: [StorySummary]
	let returned: Int
}

// MARK: StorySummary
struct StorySummary: Codable
{
	let resourceURI: String
	let name: String
	let type: ItemType

	enum ItemType: String, Codable
	{
		case cover, interiorStory, promo
		case empty = ""
	}
}

// MARK: - EventList
struct EventList: Codable
{
	let available: Int
	let collectionURI: String
	let items: [EventSummary]
	let returned: Int
}

// MARK: EventSummary
struct EventSummary: Codable
{
	let resourceURI: String
	let name: String
}

// MARK: - CharacterList
struct CharacterList: Codable
{
	let available: Int
	let collectionURI: String
	let items: [CharacterSummary]
	let returned: Int
}

// MARK: CharacterSummary
struct CharacterSummary: Codable
{
	let resourceURI: String
	let name: String
	let role: Role?
}

// MARK: - CreatorList
struct CreatorList: Codable
{
	let available: Int
	let collectionURI: String
	let items: [CreatorSummary]
	let returned: Int
}

// MARK: CreatorSummary
struct CreatorSummary: Codable
{
	let resourceURI: String
	let name: String
	let role: Role
}

// MARK: Role
enum Role: String, Codable
{
	case colorist = "colorist"
	case editor = "editor"
	case inker = "inker"
	case letterer = "letterer"
	case penciler = "penciler"
	case penciller = "penciller"
	case pencillerCover = "penciller (cover)"
	case writer = "writer"
}
