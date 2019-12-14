//
//  URLBuilder.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 14/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class URLBuilder
{
	func createURL(withHeroeName heroeName: String?) -> URL? {

		var urlComponents = URLComponents()
		urlComponents.scheme = URLConstants.scheme
		urlComponents.host = URLConstants.marvelURL
		urlComponents.path = URLConstants.charactersURL

		let timestamp = String(Int(Date().timeIntervalSince1970))
		guard let hash = HashFunctions.MD5(timestamp + APIKeys.privateKey + APIKeys.publicKey) else { return nil }

		if let heroeName = heroeName {
			urlComponents.queryItems = [
				URLQueryItem(name: URLKeysConstants.nameStartsWith, value: heroeName),
				URLQueryItem(name: URLKeysConstants.timestamp, value: timestamp),
				URLQueryItem(name: URLKeysConstants.apikey, value: APIKeys.publicKey),
				URLQueryItem(name: URLKeysConstants.hash, value: hash),
			]
		}
		else {
			urlComponents.queryItems = [
				URLQueryItem(name: URLKeysConstants.timestamp, value: timestamp),
				URLQueryItem(name: URLKeysConstants.apikey, value: APIKeys.publicKey),
				URLQueryItem(name: URLKeysConstants.hash, value: hash),
				URLQueryItem(name: URLKeysConstants.limit, value: "100"),
			]
		}

		guard let url = urlComponents.url else {
			assertionFailure("Wrong URL")
			return nil
		}
		return url
	}

	func createURL(withComicName comicName: String?) -> URL? {
		var urlComponents = URLComponents()
		urlComponents.scheme = URLConstants.scheme
		urlComponents.host = URLConstants.marvelURL
		urlComponents.path = URLConstants.comicsURL

		let timestamp = String(Int(Date().timeIntervalSince1970))
		guard let hash = HashFunctions.MD5(timestamp + APIKeys.privateKey + APIKeys.publicKey) else { return nil }

		if let comicName = comicName {
			urlComponents.queryItems = [
				URLQueryItem(name: URLKeysConstants.titleStartsWith, value: comicName),
				URLQueryItem(name: URLKeysConstants.timestamp, value: timestamp),
				URLQueryItem(name: URLKeysConstants.apikey, value: APIKeys.publicKey),
				URLQueryItem(name: URLKeysConstants.hash, value: hash),
			]
		}
		else {
			urlComponents.queryItems = [
				URLQueryItem(name: URLKeysConstants.timestamp, value: timestamp),
				URLQueryItem(name: URLKeysConstants.apikey, value: APIKeys.publicKey),
				URLQueryItem(name: URLKeysConstants.hash, value: hash),
				URLQueryItem(name: URLKeysConstants.limit, value: "100"),
			]
		}

		guard let url = urlComponents.url else {
			assertionFailure("Wrong URL")
			return nil
		}
		return url
	}

	func createURL(withAuthorName authorName: String?) -> URL? {
		var urlComponents = URLComponents()
		urlComponents.scheme = URLConstants.scheme
		urlComponents.host = URLConstants.marvelURL
		urlComponents.path = URLConstants.authorsURL

		let timestamp = String(Int(Date().timeIntervalSince1970))
		guard let hash = HashFunctions.MD5(timestamp + APIKeys.privateKey + APIKeys.publicKey) else { return nil }

		if let authorName = authorName {
			urlComponents.queryItems = [
				URLQueryItem(name: URLKeysConstants.nameStartsWith, value: authorName),
				URLQueryItem(name: URLKeysConstants.timestamp, value: timestamp),
				URLQueryItem(name: URLKeysConstants.apikey, value: APIKeys.publicKey),
				URLQueryItem(name: URLKeysConstants.hash, value: hash),
			]
		}
		else {
			urlComponents.queryItems = [
				URLQueryItem(name: URLKeysConstants.timestamp, value: timestamp),
				URLQueryItem(name: URLKeysConstants.apikey, value: APIKeys.publicKey),
				URLQueryItem(name: URLKeysConstants.hash, value: hash),
				URLQueryItem(name: URLKeysConstants.limit, value: "100"),
			]
		}

		guard let url = urlComponents.url else {
			assertionFailure("Wrong URL")
			return nil
		}
		return url
	}

	func createURL(withUrlString urlString: String) -> URL? {
		var urlComponents = URLComponents(string: urlString)

		let timestamp = String(Int(Date().timeIntervalSince1970))
		guard let hash = HashFunctions.MD5(timestamp + APIKeys.privateKey + APIKeys.publicKey) else { return nil }
		urlComponents?.queryItems = [
			URLQueryItem(name: URLKeysConstants.timestamp, value: timestamp),
			URLQueryItem(name: URLKeysConstants.apikey, value: APIKeys.publicKey),
			URLQueryItem(name: URLKeysConstants.hash, value: hash),
		]
		guard let url = urlComponents?.url else {
			assertionFailure("Wrong URL")
			return nil
		}
		return url
	}
}
