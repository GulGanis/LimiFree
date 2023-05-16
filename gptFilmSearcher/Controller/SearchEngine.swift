//
//  SearchEngine.swift
//  gptFilmSearcher
//
//  Created by Egor Ivanov on 06.04.2023.
//
import NaturalLanguage
import Foundation
import SwiftUI
import OpenAISwift

struct KinoPoisk : Identifiable {
    let id = UUID()
    let filmID : Int
    let name : String
    let description : String
    let shortedDescription : String
    let alternativeName : String
    let posterFull : String
    let posterPhone : String
    let year : Int
}

struct Film : Identifiable {
    let id = UUID()
    let title : String
    let fullTitle : String
    let image : String
    let releaseDate : String
    let runtimeStr : String
    let plot : String
    let awards : String
    let directors : String
    
}
class GPT : ObservableObject {
    @Published var kinopoiskArray = [KinoPoisk]()
    @Published var idArray : [String] = []
    @Published var linkCondition : Bool = true
    @Published var filmArray = [Film]()
    @Published var test = ""
    var choosenGenre = "%D0%B1%D0%BE%D0%B5%D0%B2%D0%B8%D0%BA" // boevik
    var authIMDBToken = "k_18li4rw4" //For api key
    let openAI = OpenAISwift(authToken: "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")
    func getRecommendation(request : String) {
        idArray = []
        filmArray = []
        let upgradedVersion = formatRequest(userRequest: request)
        openAI.sendCompletion(with: upgradedVersion, model: .gpt3(.davinci), maxTokens: 3000) { result in
            switch result {
            case .success(let success):
                print("Current key is \(self.authIMDBToken)")
                let answer = success.choices?.first?.text ?? ""
                let removed = String(answer.filter({ !"\n".contains($0)}))
                print(removed)
                let formatted = self.formatURL(unformatted: removed)
                print(formatted)
                for tries in 0...formatted.count - 1 {
                    self.fetchRequest(filmName: formatted[tries])
                }
                print(self.idArray)
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    func formatRequest(userRequest : String) -> String {
        let formatted = "Create recommended films array, separated by '/', for movie '\(userRequest)' in english"
        return formatted
    }
    func fetchRequest(filmName : String) {
        let decoder = JSONDecoder()
        if let urlString = URL(string: "https://imdb-api.com/API/Search/\(authIMDBToken)/\(filmName)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, response, error in
                if error == nil {
                    if let safeData = data {
                        do {
                            let result = try decoder.decode(Start.self, from: safeData)
                                let resulted = result.results[0].id
                            DispatchQueue.main.async {
                                self.idArray.append(resulted)
                            }
                                self.fetchFilmData(identity: resulted)
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    func fetchFilmData(identity : String) {
        let decoder = JSONDecoder()
        if let urlString = URL(string: "https://imdb-api.com/en/API/Title/\(authIMDBToken)/\(identity)/Posters") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, response, error in
                if error == nil {
                    if let safeData = data {
                        do {
                            let finalResult = try decoder.decode(filmObject.self, from: safeData) // Think of removing this async, cause memory is leaking in a big size
                                withAnimation(Animation.spring()) {
                                    DispatchQueue.main.async {
                                        withAnimation(.default) {
                                            self.filmArray.append(Film(title: finalResult.title, fullTitle: finalResult.fullTitle, image: finalResult.image, releaseDate: finalResult.releaseDate, runtimeStr: finalResult.runtimeStr ?? "No info", plot: finalResult.plot, awards: finalResult.awards, directors: finalResult.directors))
                                        }
                                    }
                                }
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func getFilmLink(year : String, filmName : String) {
        let decoder = JSONDecoder()
        let yearFormed = formatYear(unformatted: year)
        let filmFormed = formatsingleURL(unformated: filmName)
        let forcedURL = "https://api.kinopoisk.dev/v1/movie?token=8A2C6JF-1GB49WW-JHSA02Q-KR74J6E&page=1&limit=10&alternativeName=\(filmFormed)&type=movie&year=\(yearFormed)"
        if let urlString = URL(string: forcedURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, response, error in
                if error == nil {
                    if let unwrappedData = data {
                        do {
                            let result = try decoder.decode(start.self, from: unwrappedData)
                            if result.docs.count != 0 {
                                 // how to implement so it always works, cause now it works only when second time called
                                self.createLink(id: result.docs[0].id)
                            }
                            else {
                                self.linkCondition = false
                                print("Empty list.")
                            }
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func getFilmsKinopoisk(object : (String, String)) {
        kinopoiskArray = []
        let decoder = JSONDecoder()
        let filmFormed = formatsingleURL(unformated: object.0)
        var workURL = ""
        switch object.1 {
        case "болгарский":
            workURL = "https://api.kinopoisk.dev/v1/movie?token=8A2C6JF-1GB49WW-JHSA02Q-KR74J6E&page=1&limit=10&name=\(filmFormed)&type=movie"
        case "русский":
            workURL = "https://api.kinopoisk.dev/v1/movie?token=8A2C6JF-1GB49WW-JHSA02Q-KR74J6E&page=1&limit=10&name=\(filmFormed)&type=movie"
        case "genred":
            workURL = "https://api.kinopoisk.dev/v1/movie?token=8A2C6JF-1GB49WW-JHSA02Q-KR74J6E&page=1&limit=11&genres.name=\(choosenGenre)"
        default:
            workURL = "https://api.kinopoisk.dev/v1/movie?token=8A2C6JF-1GB49WW-JHSA02Q-KR74J6E&page=1&limit=10&alternativeName=\(filmFormed)&type=movie"
            
        }
        if let urlString = URL(string: workURL) {
            print(workURL)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, response, error in
                if error == nil {
                    if let unwrappedData = data {
                        do {
                            let result = try decoder.decode(FirstStep.self, from: unwrappedData)
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                                    for repeats in 0...result.docs.count - 1 {
                                        withAnimation(Animation.spring()) {
                                            self.kinopoiskArray.append(KinoPoisk(filmID: result.docs[repeats].id ?? 0, name: result.docs[repeats].name ?? "No name", description: result.docs[repeats].description ?? "No decription", shortedDescription: result.docs[repeats].shortDescription ?? "None", alternativeName: result.docs[repeats].alternativeName ?? "No alternative name", posterFull: result.docs[repeats].poster?.url ?? "No url", posterPhone: result.docs[repeats].poster?.previewUrl ?? "No url", year: result.docs[repeats].year ?? 0))
                                        }
                                    }
                                    return
                                })
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func createLink(id : Int) {
        DispatchQueue.main.async {
            self.test = "https://www.sspoisk.ru/film/\(id)"
        }
    }
    
    
    func formatURL(unformatted : String) -> [String] {
        var newString : [String] = []
        let cleanedArray = unformatted.split(separator: "/")
        for elements in cleanedArray {
            newString.append(elements.replacingOccurrences(of: " ", with: "%20"))
        }
        return newString
    }
    
    func formatYear(unformatted : String) -> String {
        let formatted = unformatted.split(separator: "-")
        print(formatted[0])
        return String(formatted[0])
    }
    
    func formatsingleURL(unformated : String) -> String {
        let formatted = unformated.replacingOccurrences(of: " ", with: "%20")
        print(formatted)
        return formatted
    }
    
    func setKey(key : String) -> Void {
        self.authIMDBToken = key
        print(self.authIMDBToken)
    }
    
    func whatLanguage(checkString : String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(checkString)
        guard let language = recognizer.dominantLanguage?.rawValue else {return nil}
        let detected = Locale.current.localizedString(forIdentifier: language)
        print(detected ?? "None")
        return detected
    }
    
    func setGenre(key : String) -> Void {
        self.choosenGenre = key
        print(self.choosenGenre)
    }
}




