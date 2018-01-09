//
//  ViewController.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 08/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var movies = [Movie]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Movie.all(forPage: 1) { (movies) in
            self.movies = movies
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndexpath = self.collectionView.indexPathsForSelectedItems!.first!
        let selectedMovie = self.movies[selectedIndexpath.row]
        
        let detailsController = segue.destination as! MovieDetailsViewController
        detailsController.currentMovie = selectedMovie
        
    }


}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentMovie = self.movies[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.labelMovieTitle.text = currentMovie.original_title
        cell.cardenize()
        currentMovie.posterImage { (image) in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showMovieDetails", sender: self)
        
    }
}

