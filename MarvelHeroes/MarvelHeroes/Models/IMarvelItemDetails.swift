//
//  IMarvelItemDetails.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 04.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

protocol IMarvelItemDetails: Decodable
{
	var id: Int { get }
	var name: String?  { get }
	var title: String? { get }
	var fullName: String? { get }
	var description: String? { get }
	var thumbnail: Thumbnail { get }
}
