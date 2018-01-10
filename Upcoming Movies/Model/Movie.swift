//
//  Movie.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 08/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import Foundation
import UIKit

struct Results : Decodable {
    var results : [Movie]
}

struct ResultsSearched : Decodable {
    var page : Int
    var results : [Movie]
}

struct MovieSearched : Decodable {
    var id : Int
    var logo_path : String?
    var name : String
    
    func movie(_ completion : @escaping (Movie)->Void) {
        let baseURL = URL(string: "https://api.themoviedb.org/3/movie/\(self.id)?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US")!
        
        URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            
            guard let data = data else {return}
            
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                completion(movie)
            } catch let errorFromCatch {
                print("Error serializing: ", errorFromCatch)
            }
            
        }.resume()
        
    }
}

class Movie : Decodable {
    
    var vote_count : Int?, id : Int
    var genre_ids : [Int]?
    var video : Bool, adult : Bool
    var vote_average : Float, popularity : Float
    var poster_path : String?, original_language : String, original_title : String, backdrop_path : String?, overview : String, release_date : String
    
    
    static var searches = [URLSessionDataTask]()
    
    static var currentSearch : URLSessionDataTask?
    
    func getGenresString(_ completion : @escaping (String)->Void) {
        
        Genre.all { (genresDictionary) in
            guard let genre_ids = self.genre_ids else { completion(""); return}
            let genresStrings = genre_ids.map { (id) -> String in
                // Forcing Optional here because genres are fixed
                return genresDictionary[id]!
            }
            
            let jointGenres : String = genresStrings.reduce("", { $0 == "" ? $1 : $0 + " | " + $1 })
            
            completion(jointGenres)
        }
    }
    
    static func all(forPage page : Int, _ completion : @escaping ([Movie])->()) {
        
        //API Key: 1f54bd990f1cdfb230adb312546d765d
        guard let upcomingURL = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US&page=\(page)") else { return }
        
        URLSession.shared.dataTask(with: upcomingURL) { (data, response, error) in

            guard let data = data else {return}

            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(results.results)
            } catch let errorFromCatch {
                print("Error serializing: ", errorFromCatch)
            }
            
        }.resume()
        
    }
    
    static func loadMovie(forID id : Int, _ completion : @escaping (Movie?)->Void) {
        
        guard let baseURL = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US") else {completion (nil); return}
        
        URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            
            guard let data = data else {return}
            
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                print(String.init(data: data, encoding: .utf8))
                completion(movie)
            } catch let errorFromCatch {
                print("Error serializing: ", errorFromCatch)
            }
            
        }.resume()
        
    }
    
    
    
    static func search(withString searchString : String, andPage page : Int, _ completion : @escaping ([Movie])->Void) {

        
        guard let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US&query=\(searchString.lowercased().replacingOccurrences(of: " ", with: "%20"))&page=\(page)") else { completion([]); return }
        
        URLSession.shared.dataTask(with: baseURL) { (data, responser, error) in
            
            guard let data = data else {completion([]); return}

            do {
                let results = try JSONDecoder().decode(ResultsSearched.self, from: data)
                completion(results.results)
            } catch let errorFromCatch {
                print("Error serializing: ", errorFromCatch)
            }
        }.resume()
        
        
    }

    func backdropImage(_ completion : @escaping (UIImage?)->Void) {
        
        guard let backdrop_path = self.backdrop_path, let posterURL = URL(string : "https://image.tmdb.org/t/p/w500\(backdrop_path)") else { completion(nil); return}
        
        URLSession.shared.dataTask(with: posterURL) { (data, responser, error) in
            guard let image = UIImage(data: data!) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
        
    }
    
    
    static var imageTasks = [IndexPath:[URLSessionDataTask]]()
    
    func posterImage(_ completion : @escaping (UIImage?)->Void) {
        
        guard let poster_path = self.poster_path, let posterURL = URL(string : "https://image.tmdb.org/t/p/w500\(poster_path)") else { completion(nil); return }
        
        URLSession.shared.dataTask(with: posterURL) { (data, responser, error) in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()

    }
}

extension Movie: Equatable {
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.original_title == rhs.original_title
    }
}
