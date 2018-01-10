//
//  MovieDetailsViewController.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 08/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageViewBackdrop: ImageLoader!
    @IBOutlet weak var imageViewBackDropFront: ImageLoader!
    
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var labelMovieDetails: UILabel!
    
    @IBOutlet weak var labelOverView: UILabel!
    
    
    var currentMovie : Movie!
    

    @IBOutlet weak var topBackdropFrontImage: NSLayoutConstraint!
    
    @IBOutlet weak var backDropHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpdateMovieDetails()

        // Do any additional setup after loading the view.
    }
    
    func UpdateMovieDetails() {
        
        self.labelMovieTitle.text = currentMovie.original_title
        
        if let year = currentMovie.release_date.split(separator: "-").first {
            self.labelMovieTitle.text! += " (" + year + ")"
        }
        
        self.currentMovie.getGenresString { (genresAsString) in
            DispatchQueue.main.async {
                self.labelMovieDetails.text = genresAsString + " - " + self.currentMovie.release_date.dateFormatted()
            }
        }
        
        self.labelOverView.text = currentMovie.overview
        
        self.imageViewBackdrop.loadImage(forMovie: currentMovie, andType: .poster, andSize: PosterSizes.low.rawValue)
        self.imageViewBackDropFront.loadImage(forMovie: currentMovie, andType: .backdrop, andSize: BackDropSizes.medium.rawValue)
        
        
    }

    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension MovieDetailsViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Gets the y Scrollview offset
        let yOffset = scrollView.contentOffset.y
        
        // Increases image size while scrolling down
        if yOffset < -20 {
            self.topBackdropFrontImage.constant = yOffset - 20
            self.backDropHeight.constant = 244 - yOffset - 20
            DispatchQueue.main.async {
                scrollView.layoutIfNeeded()
            }
        }
        
        
        // Dismiss view if slides down
        if yOffset < -100 {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}








