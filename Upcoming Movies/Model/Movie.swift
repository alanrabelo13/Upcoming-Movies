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

class Movie : Decodable {
    
    var vote_count : Int, id : Int
    var genre_ids : [Int]
    var video : Bool, adult : Bool
    var vote_average : Float, popularity : Float
    var poster_path : String, original_language : String, original_title : String, backdrop_path : String, overview : String, release_date : String
    
    static func all(forPage page : Int, _ completion : @escaping ([Movie])->()) {
        
        //
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

    func backdropImage(_ completion : @escaping (UIImage?)->Void) {
        
        let posterURL = URL(string : "https://image.tmdb.org/t/p/w500\(self.backdrop_path)")!
        
        URLSession.shared.dataTask(with: posterURL) { (data, responser, error) in
            guard let image = UIImage(data: data!) else {
                completion(nil)
                return
            }
            completion(image)
            }.resume()
        
    }
    
    func posterImage(_ completion : @escaping (UIImage?)->Void) {
        
        let posterURL = URL(string : "https://image.tmdb.org/t/p/w500\(self.poster_path)")!
        
        URLSession.shared.dataTask(with: posterURL) { (data, responser, error) in
            guard let image = UIImage(data: data!) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
        
    }
}
