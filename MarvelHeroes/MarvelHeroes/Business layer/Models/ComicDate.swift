//
//  ComicDate.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import Foundation

struct ComicDate: Codable {
    let type: DateType
    let date: Date
}

enum DateType: String, Codable {
    case focDate, onsaleDate
}
