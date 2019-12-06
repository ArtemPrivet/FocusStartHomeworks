//
//  Enums.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 06.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation

enum URLPoints
{
	static let creators = "v1/public/creators"
	static let characters = "v1/public/characters"
}
enum ServiceError: Error
{
	case invalidURL(Error)
	case invalidInputURL
	case decodingError(Error)
	case browserError
	case serverError
	case noHTTPResponse
	case convertionImageError
}
enum ImageSize
{
	static let small = "/portrait_small"
	static let medium = "/standard_medium"
	static let large = "/standard_large"
}
