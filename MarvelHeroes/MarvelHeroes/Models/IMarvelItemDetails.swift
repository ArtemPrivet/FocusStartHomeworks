//
//  IMarvelItemDetails.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 04.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

protocol IMarvelItemDetails
{
	var name: String?  { get }
	var description: String? { get }
	var title: String? { get }
	var thumbnail: Thumbnail { get }
	var fullName: String? { get }
	var resourceURI: String { get }
	var subItemsCollection: SubItemsCollection? { get }
}
