//
//  MovieTableViewCell.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 09/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageViewPoster: UIImageView!
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var labelMovieGenres: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var imageViewBackground: UIImageView!
    
    
    override func prepareForReuse() {
        self.ImageViewPoster.image = #imageLiteral(resourceName: "placeholder")
        self.imageViewBackground.image = #imageLiteral(resourceName: "placeholder")
        
    }
    

}
