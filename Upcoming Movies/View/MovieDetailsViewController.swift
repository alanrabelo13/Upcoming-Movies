//
//  MovieDetailsViewController.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 08/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageViewBackdrop: UIImageView!
    @IBOutlet weak var imageViewBackDropFront: UIImageView!
    
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var labelMovieDetails: UILabel!
    
    @IBOutlet weak var labelOverView: UILabel!
    
    
    var currentMovie : Movie!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpdateMovieDetails()

        // Do any additional setup after loading the view.
    }
    
    func UpdateMovieDetails() {
        self.labelMovieTitle.text = currentMovie.original_title + " (" + currentMovie.release_date.split(separator: "-").first! + ")"
        
        Genre.all { (genresDictionary) in
            
            let genresStrings = self.currentMovie.genre_ids.map { (id) -> String in
                // Forcing Optional here because genres are fixed
                return genresDictionary[id]!
            }
            
            let jointGenres : String = genresStrings.reduce("", { $0 == "" ? $1 : $0 + " | " + $1 })
            
            
            
            DispatchQueue.main.async {
                self.labelMovieDetails.text = jointGenres + "   " + self.currentMovie.release_date
            }
        }
        
        
        
        self.labelOverView.text = currentMovie.overview
        
        
        currentMovie.backdropImage { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.imageViewBackdrop.image = image
                    self.imageViewBackDropFront.image = image
                    UIView.animate(withDuration: 0.3, animations: {
                        self.imageViewBackdrop.alpha = 1
                        self.imageViewBackDropFront.alpha = 1

                    })
                }
            }
        }
        
    }

    @IBAction func dismissView(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

}
