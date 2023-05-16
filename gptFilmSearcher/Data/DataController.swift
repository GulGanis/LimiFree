//
//  DataController.swift
//  gptFilmSearcher
//
//  Created by Egor Ivanov on 11.04.2023.
//

import Foundation
import CoreData

class DataController : ObservableObject {
    @Published var userProfile : [UserProfile] = []
    @Published var favoriteFilms : [FavoriteFilm] = []
    let container = NSPersistentContainer(name: "Data")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.fetchProfile()
            self.fetchFilms()
        }
    }
        
        func save() -> Void {
            do {
                try container.viewContext.save()
                print("Successfully saved data.")
                fetchProfile()
                fetchFilms()
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        func addFavorite(title : String, runTimeString : String, releaseDate : String, plot : String, fullTitle : String, directors : String, awards : String, link : String) -> Void {
            let film = FavoriteFilm(context: container.viewContext)
            film.id = UUID()
            film.title = title
            film.runTimeString = runTimeString // not flashing with green?
            film.releaseDate = releaseDate
            film.plot = plot
            film.fullTitle = fullTitle
            film.directors = directors
            film.awards = awards
            film.linked = link
            favoriteFilms.append(film)
            save()
        }
        
        func fetchProfile() -> Void {
            let profileRequest = NSFetchRequest<UserProfile>(entityName: "UserProfile")
            do {
                userProfile = try container.viewContext.fetch(profileRequest)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        func fetchFilms() -> Void {
            let favoritesRequest = NSFetchRequest<FavoriteFilm>(entityName: "FavoriteFilm")
            do {
                favoriteFilms = try container.viewContext.fetch(favoritesRequest)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        func createProfile(name : String) -> Void {
            if userProfile.count == 0 {
                let profile = UserProfile(context: container.viewContext)
                profile.userName = name
                profile.askedHelp = 0
                profile.instantSearch = 0
                userProfile.append(profile)
                save()
            }
        }
        
        func deleteData() -> Void {
            userProfile = []
            favoriteFilms = []
            save()
        }
        
        func deleteItem(index : Int) {
            let removableObject = favoriteFilms[index]
            favoriteFilms.remove(at: index)
            container.viewContext.delete(removableObject) // In change of context : NSO.... Use container.viewContext.
            save()
        }
        
        func deleteAllFavorites() -> Void {
            if favoriteFilms.count > 0 {
                let stockObject = favoriteFilms[0]
                for _ in 0...favoriteFilms.count - 1 {
                    container.viewContext.delete(stockObject)
                    favoriteFilms.remove(at: 0)
                }
                save()
            }
        }
        
        func deleteProfile() -> Void {
            let removable = userProfile[0]
            userProfile.remove(at: 0)
            container.viewContext.delete(removable)
            save()
        }
        
        func plusRecomended() -> Void {
            guard userProfile != [] else {return}
            userProfile[0].askedHelp += 1
            save()
        }
        
        func plusSearch() -> Void {
            guard userProfile != [] else {return}
            userProfile[0].instantSearch += 1
            save()
        }
    }
