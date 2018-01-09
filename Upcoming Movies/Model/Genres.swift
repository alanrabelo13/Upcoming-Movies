//
//  Genres.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 09/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import Foundation

struct Genres : Decodable {
    var genres : [Genre]
}

class Genre : Decodable {
    var id : Int
    var name : String
    
    static func all(_ completion : @escaping ([Int : String])->()) {
        guard let upcomingURL = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US") else { return }
        
        URLSession.shared.dataTask(with: upcomingURL) { (data, response, error) in
            
            guard let data = data else {return}
            
            do {
                let results = try JSONDecoder().decode(Genres.self, from: data)
                
                var genresDictionary = [Int : String]()
                for genre in results.genres {
                    genresDictionary[genre.id] = genre.name
                }
                completion(genresDictionary)
                
            } catch let errorFromCatch {
                print("Error serializing: ", errorFromCatch)
            }
        }.resume()
        
    }

}

