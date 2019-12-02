//
//  ComicPrice.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

struct ComicPrice: Codable {
    let type: PriceType
    let price: Double
}

enum PriceType: String, Codable {
    case printPrice
}
