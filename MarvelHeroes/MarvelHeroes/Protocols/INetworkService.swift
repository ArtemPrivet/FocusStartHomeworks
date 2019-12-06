//
//  INetworkService.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

protocol INetworkService
{
	func getHeroes(heroeName: String?, _ completion: @escaping (HeroesResult) -> Void)
	func getImage(urlString: String, _ completion: @escaping (DataOptionalResult) -> Void )
	func getComic(withUrlString urlString: String?, _ completion: @escaping (ComicsResult) -> Void)
	func getComics(withComicName name: String?, _ completion: @escaping (ComicsResult) -> Void)
	func getAuthor(withUrlString urlString: String?, _ completion: @escaping (AuthorsResult) -> Void)
	func getAuthors(withAuthorName name: String?, _ completion: @escaping (AuthorsResult) -> Void)
}
