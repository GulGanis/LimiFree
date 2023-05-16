//
//  ContentView.swift
//  gptFilmSearcher
//
//  Created by Egor Ivanov on 06.04.2023.
//

import SwiftUI

// MARK: Standart Struct

struct ContentView: View {
    
    @State var keygen : String = "k_18li4rw4"
    @State var index : Int = 0
    let keyGenArray : [String] = ["k_18li4rw4", "k_i60hurve", "k_yxpp5kuj", "k_5o0ep8h0"]
    
    
    let colorLink = Colors()
    let palette = NewPalette()
    
    @Environment(\.openURL) var openURL
    @StateObject var data = DataController()
    
    var menuArrays : [String] = ["Full title", "Release date", "Running time", "Awards", "Director", "Preview on story"]
    @ObservedObject var main = GPT()
    @State var tabView : Int = 0
    @State var viewToggler : Bool = false
    @State var filmName : String = "Enter your film name"
    var body: some View {
        
        TabView(selection: $tabView) {
            ZStack {
                palette.gray.ignoresSafeArea()
                if viewToggler == false {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 350, height: 300)
                                .foregroundColor(palette.black)
                                .shadow(color: palette.black, radius: 10)
                            VStack {
                                ZStack {
                                    Circle()
                                        .frame(width: 100)
                                        .foregroundColor(palette.orange)
                                        .shadow(color: colorLink.myRed, radius: 10)
                                    Image(systemName: "sun.dust.circle")
                                        .font(.system(size: 75))
                                        .foregroundColor(palette.black)
                                }
                                Text("Sun treasury")
                                    .padding(.bottom, 15)
                                    .font(Font.custom("Grindleaf", size: 30))
                                    .foregroundColor(palette.orange)
                                    .shadow(color: colorLink.myRed, radius: 5, y: 5)
                                Text("Search for recommended films with help of ChatGPT, get all wished information and watch it for free with direct links.")
                                    .frame(width: 250)
                                    .foregroundColor(palette.white)
                                    .font(Font.custom("Grindleaf", size: 23))
                            }
                        }.padding()
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 300, height: 75)
                                .foregroundColor(palette.black)
                                .shadow(color: palette.black, radius: 25)
                            HStack {
                                TextField("", text: $filmName)
                                    .font(Font.custom("Grindleaf", size: 20))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .background(palette.black)
                                    .frame(width: 200, height: 50)
                                    .accentColor(.white)
                                    .onSubmit {
                                        withAnimation(.spring(response: 0.3)) {
                                            data.plusRecomended()
                                            viewToggler.toggle()
                                            main.getRecommendation(request: filmName)
                                            filmName = ""
                                        }
                                    }
                                    .onTapGesture {
                                        filmName = ""
                                    }
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        data.plusRecomended()
                                        viewToggler.toggle()
                                        main.getRecommendation(request: filmName)
                                        filmName = ""
                                    }
                                } label: {
                                    Image(systemName: "eye")
                                        .font(.system(size: 30))
                                        .foregroundColor(palette.orange)
                                        .shadow(color: colorLink.myRed, radius: 5)
                                        .padding(.bottom, 3)
                                }.buttonStyle(.borderless)
                            }.padding(.top, 5)
                        }.padding()
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 300, height: 75)
                                .foregroundColor(palette.black)
                                .shadow(color: palette.black, radius: 25) // IN WORK
                            HStack {
                                Text(keygen)
                                    .font(Font.custom("Grindleaf", size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 170, height: 50, alignment: .leading)
                                Button {
                                    switch index {
                                    case 0:
                                        index -= 0
                                        keygen = keyGenArray[index]
                                        main.setKey(key: keygen)
                                    default:
                                        index -= 1
                                        keygen = keyGenArray[index]
                                        main.setKey(key: keygen)
                                    }
                                } label: {
                                    Image(systemName: "minus.square")
                                        .font(.system(size: 30))
                                        .foregroundColor(palette.orange)
                                        .shadow(color: colorLink.myRed, radius: 5)
                                        .padding(.bottom, 3)
                                }
                                Button {
                                    switch index {
                                    case keyGenArray.count - 1:
                                        index += 0
                                        keygen = keyGenArray[index]
                                        main.setKey(key: keygen)
                                    default:
                                        index += 1
                                        keygen = keyGenArray[index]
                                        main.setKey(key: keygen)
                                    }
                                } label: {
                                    Image(systemName: "plus.square")
                                        .font(.system(size: 30))
                                        .foregroundColor(palette.orange)
                                        .shadow(color: colorLink.myRed, radius: 5)
                                        .padding(.bottom, 3)
                                }
                            }
                        }
                    }
                }
                else {
                    VStack {
                        Text("Recommended for you")
                            .font(Font.custom("PaybAck", size: 25))
                            .padding()
                            .foregroundColor(Color.black)
                            .background(RoundedRectangle(cornerRadius: 20).fill(palette.orange).shadow(color: colorLink.myRed, radius: 10))
                            .padding()
                        switch main.filmArray.count {
                        case 0:
                            ProgressView().tint(palette.orange)
                        default:
                            ScrollView(.vertical, showsIndicators: false) {
                            ForEach(main.filmArray.indices, id: \.self) { element in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(0...1, id: \.self) { horyzontal in
                                            VStack {
                                                Text(main.filmArray[element].title)
                                                    .foregroundColor(Color.black) // Standart black or from preset?
                                                    .font(Font.custom("Allstar", size: 50))
                                                    .padding()
                                                    .background(RoundedRectangle(cornerRadius: 20).fill(palette.orange).shadow(color: colorLink.myRed, radius: 5, y: 5))
                                                    .opacity(horyzontal == 1 ? 0 : 1)
                                                    .frame(width: 270, height: 80, alignment: .center)
                                                    .minimumScaleFactor(0.1)
                                                    .lineLimit(3)
                                                    .contextMenu(menuItems: {
                                                        Button {
                                                            data.addFavorite(title: main.filmArray[element].title,
                                                                             runTimeString: main.filmArray[element].runtimeStr,
                                                                             releaseDate: main.filmArray[element].releaseDate,
                                                                             plot: main.filmArray[element].plot,
                                                                             fullTitle: main.filmArray[element].fullTitle,
                                                                             directors: main.filmArray[element].directors,
                                                                             awards: main.filmArray[element].awards,
                                                                             link: main.test)
                                                        } label: {
                                                            Label("Add to favorites", systemImage: "hand.thumbsup.fill")
                                                        }
                                                        Button {
                                                            main.getFilmLink(year: main.filmArray[element].releaseDate, filmName: main.filmArray[element].title)
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                                                                if main.linkCondition == true {
                                                                    openURL(URL(string: main.test)!)
                                                                }
                                                                else {
                                                                    main.linkCondition = true
                                                                }
                                                            })
                                                        } label: {
                                                            Label("Get a link for watching", systemImage: "eyes")
                                                        }
                                                        
                                                    })
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .foregroundColor(palette.black)
                                                        .frame(width: 330, height: 330)
                                                        .shadow(color: .black, radius: 8)
                                                    switch horyzontal {
                                                    case 0:
                                                        //
                                                        AsyncImage(url: URL(string: main.filmArray[element].image)) { image in
                                                            image.resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(maxWidth: 330, maxHeight: 330)
                                                        } placeholder: {
                                                            ProgressView()
                                                        }
                                                    case 1:
                                                        VStack {
                                                            Text("Information")
                                                                .foregroundColor(palette.black)
                                                                .font(Font.custom("Grindleaf", size: 25))
                                                                .padding()
                                                                .background(RoundedRectangle(cornerRadius: 20).fill(palette.orange).shadow(color: colorLink.myRed, radius: 5, y: 5))
                                                                .padding()
                                                            List {
                                                                ForEach(menuArrays.indices, id: \.self) { index in
                                                                    Section(header: Text(menuArrays[index])
                                                                        .font(Font.custom("Allstar", size: 25))
                                                                        .foregroundColor(palette.orange)
                                                                            
                                                                    ) {
                                                                        switch index {
                                                                        case 0:
                                                                            Text(main.filmArray[element].fullTitle)
                                                                                .font(Font.custom("Grindleaf", size: 20))
                                                                                .foregroundColor(Color.black)
                                                                        case 1:
                                                                            Text(main.filmArray[element].releaseDate)
                                                                                .font(Font.custom("Grindleaf", size: 20))
                                                                                .foregroundColor(Color.black)
                                                                        case 2:
                                                                            Text(main.filmArray[element].runtimeStr)
                                                                                .font(Font.custom("Grindleaf", size: 20))
                                                                                .foregroundColor(Color.black)
                                                                        case 3:
                                                                            Text(main.filmArray[element].awards)
                                                                                .font(Font.custom("Grindleaf", size: 20))
                                                                                .foregroundColor(Color.black)
                                                                        case 4:
                                                                            Text(main.filmArray[element].directors)
                                                                                .font(Font.custom("Grindleaf", size: 20))
                                                                                .foregroundColor(Color.black)
                                                                        case 5:
                                                                            Text(main.filmArray[element].plot)
                                                                                .font(Font.custom("Grindleaf", size: 20))
                                                                                .foregroundColor(Color.black)
                                                                        default:
                                                                            Text("Nothing")
                                                                        }
                                                                    }
                                                                }.listRowBackground(palette.white)
                                                            }.scrollContentBackground(.hidden)
                                                        }
                                                    default:
                                                        EmptyView()
                                                    }
                                                }
                                                .padding()
                                            }
                                        }
                                    }
                                }
                            }.padding()
                            }.transition(.slide)
                        }
                        ZStack {
                            Circle()
                                .frame(width: 50)
                                .foregroundColor(palette.orange)
                                .shadow(color: colorLink.myRed, radius: 10)
                            Button {
                                withAnimation(Animation.easeInOut) {
                                    viewToggler = false
                                    filmName = "Enter your film name"
                                }
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.black)
                                    .font(.system(size: 30))
                            }
                        }.padding()
                    }
                }
            }.tabItem {
                Image(systemName: "magnifyingglass.circle")
                Text("Search")
            }.tag(0)
                .toolbarBackground(palette.white, for: .tabBar)
        FavoritesList()
                .tabItem {
                    Image(systemName: "star.circle")
                    Text("Favorites")
                    
                }.tag(1)
                .toolbarBackground(palette.white, for: .tabBar)
            instaSearch()
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Instant")
                }.tag(2)
                .toolbarBackground(palette.white, for: .tabBar)
            ProfileScreen()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }.tag(3)
                .toolbarBackground(palette.white, for: .tabBar)
        }
        .accentColor(palette.orange)
            .environmentObject(data)
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Favorites Model

struct FavoritesList: View {
    @EnvironmentObject var data : DataController
    let anotherOne = Colors()
    let palette = NewPalette()
    var body: some View {
        ZStack {
            palette.gray.ignoresSafeArea()
            VStack {
                switch data.favoriteFilms.count {
                case 0:
                    Text("No films here...\nYou should add something before we continue...")
                        .font(Font.custom("Grindleaf", size: 35))
                        .foregroundColor(.black)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(palette.orange).shadow(color: anotherOne.myRed, radius: 5, y: 5))
                default:
                Text("Favorites")
                    .font(Font.custom("PaybAck", size: 35))
                    .foregroundColor(.black)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(palette.orange).shadow(color: anotherOne.myRed, radius: 5, y: 5))
                
                List {
                    ForEach(data.favoriteFilms.indices, id: \.self) { filmed in
                        Section(header: Text(data.favoriteFilms[filmed].title!).font(Font.custom("Allstar", size: 30)).foregroundColor(palette.orange).shadow(color: anotherOne.myRed, radius: 1, y: 4)) {
                            Text(data.favoriteFilms[filmed].fullTitle!)
                                .foregroundColor(.black)
                                .font(Font.custom("Grindleaf", size: 20))
                            Text(data.favoriteFilms[filmed].releaseDate!)
                                .foregroundColor(.black)
                                .font(Font.custom("Grindleaf", size: 20))
                            Text(data.favoriteFilms[filmed].runTimeString!)
                                .foregroundColor(.black)
                                .font(Font.custom("Grindleaf", size: 20))
                            Text(data.favoriteFilms[filmed].directors!)
                                .foregroundColor(.black)
                                .font(Font.custom("Grindleaf", size: 20))
                            Text(data.favoriteFilms[filmed].awards! == "" ? "No information" : data.favoriteFilms[filmed].awards!)
                                .foregroundColor(.black)
                                .font(Font.custom("Grindleaf", size: 20))
                            Text(data.favoriteFilms[filmed].plot!)
                                .foregroundColor(.black)
                                .font(Font.custom("Grindleaf", size: 20))
                            HStack {
                                Spacer()
                                Button {
                                    withAnimation(Animation.spring()) {
                                        data.deleteItem(index: filmed)
                                    }
                                } label: {
                                    Image(systemName: "trash.square.fill")
                                        .font(.system(size: 15))
                                        .padding()
                                        .foregroundColor(Color.black)
                                        .background(RoundedRectangle(cornerRadius: 20).fill(palette.orange))
                                        .padding()
                                }.buttonStyle(.borderless)
                            }
                        }
                    }.listRowBackground(palette.white)
                }.scrollContentBackground(.hidden)
                    .padding()
            }
                }
            }
        }
    }

// MARK: Instant Seacrh

struct instaSearch : View {
    @State var keygen : String = "боевик"
    @State var index : Int = 0
    @State var modeSwitcher : Bool = false
    let keyGenArray : [[String]] = [["боевик", "%D0%B1%D0%BE%D0%B5%D0%B2%D0%B8%D0%BA"],
                                    ["комедия", "%D0%BA%D0%BE%D0%BC%D0%B5%D0%B4%D0%B8%D1%8F"],
                                    ["мультфильм", "%D0%BC%D1%83%D0%BB%D1%8C%D1%82%D1%84%D0%B8%D0%BB%D1%8C%D0%BC"],
                                    ["ужасы", "%D1%83%D0%B6%D0%B0%D1%81%D1%8B"],
                                    ["фантастика", "%D1%84%D0%B0%D0%BD%D1%82%D0%B0%D1%81%D1%82%D0%B8%D0%BA%D0%B0"],
                                    ["триллер", "%D1%82%D1%80%D0%B8%D0%BB%D0%BB%D0%B5%D1%80"],
                                    ["мелодрама", "%D0%BC%D0%B5%D0%BB%D0%BE%D0%B4%D1%80%D0%B0%D0%BC%D0%B0"],
                                    ["детектив", "%D0%B4%D0%B5%D1%82%D0%B5%D0%BA%D1%82%D0%B8%D0%B2"],
                                    ["приключения", "%D0%BF%D1%80%D0%B8%D0%BA%D0%BB%D1%8E%D1%87%D0%B5%D0%BD%D0%B8%D1%8F"],
                                    ["фэнтези", "%D1%84%D1%8D%D0%BD%D1%82%D0%B5%D0%B7%D0%B8"],
                                    ["военный", "%D0%B2%D0%BE%D0%B5%D0%BD%D0%BD%D1%8B%D0%B9"],
                                    ["криминал", "%D0%BA%D1%80%D0%B8%D0%BC%D0%B8%D0%BD%D0%B0%D0%BB"],
                                    ["драма", "%D0%B4%D1%80%D0%B0%D0%BC%D0%B0"]]
    
    var menuSectionsArray : [String] = []
    @EnvironmentObject var data : DataController
    @Environment(\.openURL) var openURL
    @State var viewSwicther : Int = 0
    @State var searchQuerry : String = "Enter your film name"
    @StateObject var main = GPT()
    let colorLink = Colors()
    let palette = NewPalette()
    var body: some View {
        ZStack {
            palette.gray.ignoresSafeArea()
            VStack {
                switch viewSwicther {
                case 0:
                    Text("Instant search")
                        .foregroundColor(palette.orange)
                        .font(Font.custom("Grindleaf", size: 35))
                        .underline()
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(palette.black).shadow(color: palette.black, radius: 10))
                        .padding()
                    Text("Press 3 times on screen to change search mode.")
                        .foregroundColor(palette.orange)
                        .font(Font.custom("Grindleaf", size: 25))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(palette.black).shadow(color: palette.black, radius: 10))
                        .padding()
                    switch modeSwitcher {
                    case false:
                        Text("Enter your film name and press an eye icon or enter on a virtual keyboard.")
                            .foregroundColor(.white)
                            .font(Font.custom("Grindleaf", size: 25))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(palette.black).shadow(color: palette.black, radius: 10))
                            .padding()
                            .transition(.push(from: .top))
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 300, height: 75)
                                .foregroundColor(palette.black)
                                .shadow(color: palette.black, radius: 25)
                            HStack {
                                TextField("", text: $searchQuerry)
                                    .font(Font.custom("Grindleaf", size: 20))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .background(palette.black)
                                    .frame(width: 200, height: 50)
                                    .accentColor(.white)
                                    .onSubmit {
                                        withAnimation(.spring(response: 0.3)) {
                                            let passedObject : (String, String) = (searchQuerry, main.whatLanguage(checkString: searchQuerry) ?? "None")
                                            data.plusSearch()
                                            main.getFilmsKinopoisk(object: passedObject)
                                            viewSwicther = 1
                                            searchQuerry = ""
                                            // Action for search
                                        }
                                    }
                                    .onTapGesture {
                                        searchQuerry = ""
                                    }
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        let passedObject : (String, String) = (searchQuerry, main.whatLanguage(checkString: searchQuerry) ?? "None")
                                        data.plusSearch()
                                        main.getFilmsKinopoisk(object: passedObject)
                                        viewSwicther = 1
                                        searchQuerry = ""
                                        // Action for search
                                    }
                                } label: {
                                    Image(systemName: "eye")
                                        .font(.system(size: 30))
                                        .foregroundColor(palette.orange)
                                        .shadow(color: colorLink.myRed, radius: 5)
                                        .padding(.bottom, 3)
                                }.buttonStyle(.borderless)
                            }.padding(.top, 5)
                        }.padding()
                            .transition(.push(from: .top))
                        
                    default:
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 300, height: 75)
                                .foregroundColor(palette.black)
                                .shadow(color: palette.black, radius: 25) // IN WORK
                            HStack {
                                Text(keygen)
                                    .font(Font.custom("Moderne Fette SchwabacherC", size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 170, height: 50, alignment: .leading)
                                Button {
                                    switch index {
                                    case 0:
                                        index -= 0
                                        keygen = keyGenArray[index][0]
                                        main.setGenre(key: keyGenArray[index][1])
                                    default:
                                        index -= 1
                                        keygen = keyGenArray[index][0]
                                        main.setGenre(key: keyGenArray[index][1])
                                    }
                                } label: {
                                    Image(systemName: "minus.square")
                                        .font(.system(size: 30))
                                        .foregroundColor(palette.orange)
                                        .shadow(color: colorLink.myRed, radius: 5)
                                        .padding(.bottom, 3)
                                }
                                Button {
                                    switch index {
                                    case keyGenArray.count - 1:
                                        index += 0
                                        keygen = keyGenArray[index][0]
                                        main.setGenre(key: keyGenArray[index][1])
                                    default:
                                        index += 1
                                        keygen = keyGenArray[index][0]
                                        main.setGenre(key: keyGenArray[index][1])
                                    }
                                } label: {
                                    Image(systemName: "plus.square")
                                        .font(.system(size: 30))
                                        .foregroundColor(palette.orange)
                                        .shadow(color: colorLink.myRed, radius: 5)
                                        .padding(.bottom, 3)
                                }
                            }
                        }.padding()
                            .transition(.push(from: .top))
                        ZStack {
                            Circle()
                                .frame(width: 80)
                                .foregroundColor(palette.orange)
                                .shadow(color: colorLink.myRed, radius: 10)
                            Button {
                                withAnimation(Animation.default) {
                                    data.plusSearch()
                                    main.getFilmsKinopoisk(object: ("None", "genred"))
                                    viewSwicther = 1
                                }
                            } label: {
                                Image(systemName: "arrowshape.turn.up.right.circle.fill")
                                    .foregroundColor(.black)
                                    .font(.system(size: 50))
                            }.buttonStyle(.borderless)
                        }.padding()
                            .transition(.opacity)
                    }
                    Spacer()
                case 1:
                    Text("Matching results")
                        .font(Font.custom("Grindleaf", size: 25))
                        .foregroundColor(.black)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 25).fill(palette.orange).shadow(color: colorLink.myRed, radius: 10))
                        .padding()
                        .transition(.scale(scale: 0.5))
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 350, height: 120)
                            .foregroundColor(palette.black)
                            .shadow(color: palette.black, radius: 10)
                        Text("Pick a film that matches your request.\nLast line of description is a button, press it to watch a film without any payment or subscription.")
                            .font(Font.custom("Grindleaf", size: 20))
                            .foregroundColor(.white)
                            .frame(width: 300)
                    }.padding()
                        .transition(.scale(scale: 0.5))
                    switch main.kinopoiskArray.count {
                    case 0:
                        ProgressView()
                            .tint(palette.orange)
                    default:
                        List {
                            ForEach(main.kinopoiskArray.indices, id: \.self) { indexfor in
                                Section(header: Text(main.kinopoiskArray[indexfor].name).foregroundColor(palette.orange).shadow(color: colorLink.myRed, radius: 1, y: 4).font(Font.custom("Moderne Fette SchwabacherC", size: 30)).padding()) {
                                    AsyncImage(url: URL(string: main.kinopoiskArray[indexfor].posterFull)) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 300, maxHeight: 300)
                                    } placeholder: {
                                        ProgressView().tint(.black)
                                    }
                                    Text(main.kinopoiskArray[indexfor].alternativeName)
                                        .foregroundColor(.black)
                                        .font(Font.custom("Grindleaf", size: 25))
                                        .listRowSeparator(.hidden)
                                    Text(main.kinopoiskArray[indexfor].description)
                                        .foregroundColor(.black)
                                        .font(Font.custom("Moderne Fette SchwabacherC", size: 20))
                                        .listRowSeparator(.hidden)
                                    Text(main.kinopoiskArray[indexfor].shortedDescription)
                                        .foregroundColor(.black)
                                        .font(Font.custom("Moderne Fette SchwabacherC", size: 20))
                                        .listRowSeparator(.hidden)
                                    Text("\(String(main.kinopoiskArray[indexfor].year))")
                                        .foregroundColor(.black)
                                        .font(Font.custom("Grindleaf", size: 25))
                                        .listRowSeparator(.hidden)
                                    Text("\(String(main.kinopoiskArray[indexfor].filmID))")
                                        .foregroundColor(.black)
                                        .font(Font.custom("Grindleaf", size: 25))
                                        .listRowSeparator(.hidden)
                                    HStack {
                                        Text("Open a direct link")
                                            .font(Font.custom("Grindleaf", size: 25))
                                            .foregroundColor(palette.orange)
                                        Spacer()
                                        Button {
                                            withAnimation(Animation.default) {
                                                viewSwicther = 2
                                            }
                                            main.createLink(id: main.kinopoiskArray[indexfor].filmID)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                                                withAnimation(Animation.default) {
                                                    viewSwicther = 1
                                                }
                                                openURL(URL(string: main.test)!)
                                            })
                                        } label: {
                                            Image(systemName: "arrow.up.forward.app")
                                                .font(.system(size: 25))
                                                .foregroundColor(palette.orange)
                                        }.buttonStyle(.borderless)
                                    }.listRowSeparator(.hidden)
                                }
                            }.listRowBackground(palette.white)
                        }.scrollContentBackground(.hidden)
                            .transition(.slide)
                    }
                    ZStack {
                        Circle()
                            .frame(width: 50)
                            .foregroundColor(palette.orange)
                            .shadow(color: colorLink.myRed, radius: 10)
                        Button {
                            withAnimation(Animation.default) {
                                viewSwicther = 0
                                searchQuerry = "Enter your film name"
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.black)
                                .font(.system(size: 30))
                        }
                    }.padding()
                case 2:
                    Sheet()
                        .transition(.slide)
                default:
                    ProgressView()
            }
            }
        }.onTapGesture(count: 2, perform: {
            withAnimation(Animation.easeIn) {
                modeSwitcher.toggle()
            }
        })
    }
    
    func tupleGenerator(filmName : String, language : String) -> (String, String) {
        return (filmName, language)
    }
}

struct Sheet: View {
    @Environment(\.dismiss) var dismiss
    let palette = NewPalette()
    let linked = Colors()
    var body: some View {
        ZStack {
            palette.gray.ignoresSafeArea()
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 300, height: 330)
                        .foregroundColor(palette.black)
                        .shadow(color: palette.black, radius: 10)
                    VStack {
                        Text("WARNING!")
                            .font(Font.custom("Allstar", size: 35))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(palette.orange).shadow(color: linked.myRed, radius: 10))
                            .padding(.top, 30)
                        Text("We are looking for a film in our database. \nThe link will be automatically opened in 3 seconds.")
                            .font(Font.custom("Grindleaf", size: 20))
                            .foregroundColor(.white)
                            .frame(width: 250, height: 200)
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 80, height: 80)
                        .foregroundColor(palette.orange)
                        .shadow(color: linked.myRed, radius: 10)
                        .padding()
                    ProgressView().tint(.black).scaleEffect(2)
                }
                Button {
                    dismiss()
                } label: {
                    Text("Dismiss")
                        .font(Font.custom("Grindleaf", size: 35))
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(palette.black).shadow(color: palette.black, radius: 10))
                        .padding()
                }
            }
        }
    }
}

struct ProfileScreen : View {
    @EnvironmentObject var data : DataController
    @State var profileName : String = "Enter your name"
    var scrollArray : [[String]] = [["Clear favorites tab", "trash.circle.fill", "Removes all your films from favorites table"], ["Clear profile", "xmark.circle", "Removes your profile and clears all your stats."]]
    let palette = NewPalette()
    let linked = Colors()
    var body: some View {
        ZStack {
            palette.gray.ignoresSafeArea()
            switch data.userProfile.count {
            case 0:
                VStack {
                    Text("No profile...\nCreate it so you can see your stats in a real time")
                        .font(Font.custom("Grindleaf", size: 35))
                        .foregroundColor(.black)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(palette.orange).shadow(color: linked.myRed, radius: 5, y: 5))
                        .padding()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 250, height: 80)
                            .foregroundColor(palette.black)
                            .shadow(color: palette.black, radius: 10)
                        TextField("", text: $profileName)
                            .font(Font.custom("Grindleaf", size: 20))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .background(palette.black)
                            .frame(width: 200, height: 50)
                            .accentColor(.white)
                            .autocorrectionDisabled()
                            .onSubmit {
                                withAnimation(.spring(response: 0.3)) {
                                    data.createProfile(name: profileName)
                                    profileName = ""
                                }
                            }
                            .onTapGesture {
                                profileName = ""
                            }
                    }.padding()
                    Button {
                        withAnimation(.spring(response: 0.5)) {
                            data.createProfile(name: profileName)
                            profileName = ""
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 75)
                                .shadow(color: linked.myRed, radius: 5, y: 5)
                            Image(systemName: "person.fill.badge.plus")
                                .font(.system(size: 35))
                                .foregroundColor(.black)
                        }
                    }
                }.transition(.scale(scale: -0.5))
            default:
                VStack {
                    Text("\(data.userProfile[0].userName!)'s screen")
                        .font(Font.custom("Grindleaf", size: 35))
                        .foregroundColor(.black)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(palette.orange).shadow(color: linked.myRed, radius: 5, y: 5))
                        .padding()
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 350, height: 200)
                            .foregroundColor(palette.black)
                            .shadow(color: palette.black, radius: 10)
                            .padding()
                        VStack {
                            Text("Total recomendations asked: \(data.userProfile[0].askedHelp)")
                                .foregroundColor(.white)
                                .font(Font.custom("Grindleaf", size: 20))
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 40).fill(palette.gray).shadow(color: linked.myRed, radius: 5, y: 5))
                                .padding()
                            Text("Total searched films: \(data.userProfile[0].instantSearch)")
                                .foregroundColor(.white)
                                .font(Font.custom("Grindleaf", size: 20))
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 40).fill(palette.gray).shadow(color: linked.myRed, radius: 5, y: 5))
                                .padding()
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0...1, id: \.self) { horyzontalic in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 350, height: 300)
                                        .padding(.leading, 10)
                                        .foregroundColor(palette.black)
                                    VStack {
                                        Text(scrollArray[horyzontalic][0])
                                            .font(Font.custom("Grindleaf", size: 25))
                                            .foregroundColor(.black)
                                            .padding()
                                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(palette.orange).shadow(color: linked.myRed, radius: 5, y: 5))
                                            .padding()
                                        Text(scrollArray[horyzontalic][2])
                                            .foregroundColor(.white)
                                            .font(Font.custom("Grindleaf", size: 18))
                                            .padding()
                                            .background(RoundedRectangle(cornerRadius: 40).fill(palette.gray).shadow(color: linked.myRed, radius: 5, y: 5))
                                        ZStack {
                                            Circle()
                                                .frame(width: 100)
                                                .foregroundColor(palette.gray)
                                                .shadow(color: linked.myRed, radius: 5)
                                            Button {
                                                switch horyzontalic {
                                                case 0:
                                                    data.deleteAllFavorites()
                                                default:
                                                    withAnimation(.default) {
                                                        data.deleteProfile()
                                                        profileName = "Enter your name"
                                                    }
                                                    
                                                }
                                                
                                            } label: {
                                                Image(systemName: scrollArray[horyzontalic][1])
                                                    .font(.system(size: 70))
                                                    .foregroundColor(.white)
                                            }
                                        }.padding()
                                    }.padding(.leading, 15)
                                }
                                    
                            }.padding()
                        }
                    }
                }.transition(.move(edge: .top))
            }
        }
    }
}
