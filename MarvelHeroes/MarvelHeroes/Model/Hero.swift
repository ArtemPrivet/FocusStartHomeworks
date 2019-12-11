// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let empty = try? newJSONDecoder().decode(Empty.self, from: jsonData)

import Foundation

struct CharacterDataWrapper: Decodable
{
	let data: CharacterDataContainer?
}

struct CharacterDataContainer: Decodable
{
	let results: [Character]?
}
struct Character: Decodable
{
	let id: Int?
	let name: String?
	var description: String?
	let thumbnail: Image?
}
struct Image: Decodable
{
	let path: String?
	let enlargement: String?

	enum CodingKeys: String, CodingKey
	{
		case path = "path"
		case enlargement = "extension"
	}
}

typealias DataResult = Result<Data, ServiceError>
typealias CharacterResult = Result<CharacterDataWrapper, ServiceError>
