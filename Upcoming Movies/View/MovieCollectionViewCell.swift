//
//  MovieCollectionViewCell.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 08/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!    
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var labelGenre: UILabel!
    
    override func prepareForReuse() {
        self.imageView.image = nil
        self.labelMovieTitle.text = nil
    }
}


