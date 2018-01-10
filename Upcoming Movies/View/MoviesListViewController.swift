//
//  ViewController.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 08/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    var dataSource = [Movie]()
    
    var selectedIndex : IndexPath?
    var currentPage = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This function receives in the completion a list with data about movies (without images)
        Movie.all(forPage: currentPage) { (movies) in
            
            self.dataSource = movies
            
            // Use main thread for UI Updates
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMovieDetails" {
            // Get selected indexpath to select item to show in detais controller
            let selectedIndexpath = self.tableView.indexPathForSelectedRow!
            let selectedMovie = self.dataSource[selectedIndexpath.row]
            
            let detailsController = segue.destination as! MovieDetailsViewController
            
            // Sets the current movie in details controller
            detailsController.currentMovie = selectedMovie
            self.tableView.deselectRow(at: selectedIndexpath, animated: true)
        } else {
            let searchController = segue.destination as! ViewController
            searchController.dataSource = self.dataSource
        }

        
    }
    
    
}


extension MoviesListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMovie = self.dataSource[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell") as! MovieTableViewCell
        cell.ImageViewPoster.image = nil
        cell.imageViewBackground.image = nil
        
        //dequeueReusableCell(withReuseIdentifier: "MoviesCell", for: indexPath) as! MovieTableViewCell
        
        cell.labelMovieTitle.text = currentMovie.original_title
        
        // It gets the poster image asyncronously if the movie has one
        cell.ImageViewPoster.loadImage(forMovie: currentMovie, andType: .poster, andSize: PosterSizes.low.rawValue)
        cell.imageViewBackground.loadImage(forMovie: currentMovie, andType: .poster, andSize: PosterSizes.low.rawValue)
        
        // Gets the Genres and Release Date for the movie
        currentMovie.getGenresString({ (string) in
            DispatchQueue.main.async {
                cell.labelMovieGenres.text = string
            }
        })
        
        cell.labelReleaseDate.text = currentMovie.release_date.dateFormatted()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showMovieDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // If reaches the end of the collection view...
        if indexPath.row == dataSource.count - 1 {
            
            // Updates the current page of the api to get new data
            currentPage += 1
            
            
            // Call the function to get new data with the current page
            Movie.all(forPage: currentPage, { (movies) in
                
                
                // Verify if its the last page of data
                if movies.isEmpty {
                    self.currentPage -= 1
                    return
                }
                
                // Get the indexpathes to add in collection view (Reloading this much of data is not good 😉)
                var currentIndex = -1
                let indexPaths = movies.map({ (movie) -> IndexPath in
                    currentIndex += 1
                    return IndexPath(item: self.dataSource.count + currentIndex, section: 0)
                })
                
                // Appends new movies in the end of datasource array
                self.dataSource.append(contentsOf: movies)
                
                // Insert items in the main thread
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                    
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    
                    //insertItems(at: indexPaths)
                }
            })
        }
    }
    
}


