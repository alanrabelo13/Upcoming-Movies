//
//  Movie.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 08/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import Foundation
import UIKit

enum ImageType {
    case poster
    case backdrop
}

enum PosterSizes : String {
    case thumb = "w92"
    case low = "w154"
    case medium = "w342"
    case high = "w780"
    case original = "original"
}

enum BackDropSizes : String {
    case low = "w300"
    case medium = "w780"
    case high = "w1280"
    case original = "original"
}

// This Struct is used to unzip data parsed in an array of Movie
struct Results : Decodable {
    var results : [Movie]
}

// I used decodable for ease JSON parsing task
class Movie : Decodable {
    
    var vote_count : Int?, id : Int
    var genre_ids : [Int]?
    var video : Bool, adult : Bool
    var vote_average : Float, popularity : Float
    var poster_path : String?, original_language : String, original_title : String, backdrop_path : String?, overview : String, release_date : String
    
    // This function get all genres from API and returns a formatted string with current movie array of genres
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
    
    // This function gets movies from Upcoming section of the api
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
    
    // Utilizes API for searching movies with a string, uses pagination instead of loading all stuff for reducing network usage
    static func search(withString searchString : String, andPage page : Int, _ completion : @escaping ([Movie])->Void) {
        
        guard let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US&query=\(searchString.lowercased().addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)&page=\(page)") else { completion([]); return }
        
        URLSession.shared.dataTask(with: baseURL) { (data, responser, error) in
            
            guard let data = data else {completion([]); return}

            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(results.results)
            } catch let errorFromCatch {
                print("Error serializing: ", errorFromCatch)
            }
        }.resume()
        
        
    }

}

// Needed to compare movies objects
extension Movie: Equatable {
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.original_title == rhs.original_title
    }
}
