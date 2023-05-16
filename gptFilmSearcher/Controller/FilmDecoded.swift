//
//  FilmDecoded.swift
//  gptFilmSearcher
//
//  Created by Egor Ivanov on 06.04.2023.
//

import Foundation

struct Start : Codable {
    let results : [Films]
}
struct Films : Codable {
    let id : String
}

struct filmObject : Codable {
    let title : String
    let fullTitle : String
    let image : String
    let releaseDate : String
    let runtimeStr : String?
    let plot : String
    let awards : String
    let directors : String
}


struct start : Codable {
    let docs : [object]
}

struct object : Codable {
    let id : Int
}

// For start in KinoPoisk

struct FirstStep : Codable {
    let docs : [kinoObject]
}

struct kinoObject : Codable {
    let id : Int?
    let year : Int?
    let name : String?
    let description : String?
    let poster : PostedPics?
    let alternativeName : String?
    let shortDescription : String?
    
}

struct PostedPics : Codable {
    let url : String?
    let previewUrl : String?
}
