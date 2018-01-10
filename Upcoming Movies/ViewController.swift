//
//  ViewController.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 08/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataSource = [Movie]()
    var currentPage = 1
    var lastSerch : String = ""

    
    let searchQueue = OperationQueue()
    let semaphore = DispatchSemaphore(value: 1)

        
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchQueue.qualityOfService = .userInteractive

        
        // This function receives in the completion a list with data about movies (without images)
        Movie.all(forPage: currentPage) { (movies) in
            
            self.dataSource = movies
           
            // Use main thread for UI Updates
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get selected indexpath to select item to show in detais controller
        let selectedIndexpath = self.collectionView.indexPathsForSelectedItems!.first!
        let selectedMovie = self.dataSource[selectedIndexpath.row]
        
        let detailsController = segue.destination as! MovieDetailsViewController
        
        // Sets the current movie in details controller
        detailsController.currentMovie = selectedMovie
        
    }
    
    
}


extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentMovie = self.dataSource[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.labelMovieTitle.text = currentMovie.original_title
        
        // This functions adds a fancy shadow and add a corner radius to the cell
        cell.cardenize()
        
        // It gets the poster image asyncronously if the movie has one
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
//        // If reaches the end of the collection view...
//        if indexPath.row == dataSource.count - 1 {
//
//            // Updates the current page of the api to get new data
//            currentPage += 1
//
//
//            // Call the function to get new data with the current page
//            Movie.all(forPage: currentPage, { (movies) in
//
//
//                // Verify if its the last page of data
//                if movies.isEmpty {
//                    self.currentPage -= 1
//                    return
//                }
//
//                // Get the indexpathes to add in collection view (Reloading this much of data is not good 😉)
//                var currentIndex = -1
//                let indexPaths = movies.map({ (movie) -> IndexPath in
//                    currentIndex += 1
//                    return IndexPath(item: self.dataSource.count + currentIndex, section: 0)
//                })
//
//                // Appends new movies in the end of datasource array
//                self.dataSource.append(contentsOf: movies)
//
//                // Insert items in the main thread
//                DispatchQueue.main.async {
//                    self.collectionView.insertItems(at: indexPaths)
//                }
//            })
//        }
    }
    
}

extension ViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    
        print("Entrando na funçaão")
        semaphore.wait()
        
        searchQueue.cancelAllOperations()
        self.dataSource = []
        self.collectionView.reloadData()
        
        print("Saiu da Funçaão")
        semaphore.signal()
        
        // Initiating a Semaphore for resolving datasource cells x movies conflict while inserting new items
        
        guard let text = searchBar.text else { return }
        
        
        
        searchQueue.addOperation {
            
            Movie.search(withString: text, andPage: 1) { (moviesSearched) in
                
                self.dataSource.removeAll()
                
                for movie in moviesSearched {
                    
                    
                    Movie.loadMovie(forID: movie.id, { (movie) in
                        
                        
                        DispatchQueue.main.async {
                            
                            self.semaphore.wait()
                            print("Semáforo carregando filme")
                            
                            self.dataSource.append(movie!)
                            
                            if !self.dataSource.isEmpty {
                                let lastIndexpath = IndexPath(item: self.dataSource.count-1, section: 0)
                                self.collectionView.insertItems(at: [lastIndexpath])
                            } else {
                                self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                            }
                            
                            print("Semáforo carregando filme - Saiu")
                            
                            self.semaphore.signal()
                        }
                        
                        
                    })
                }
            }
            
        }
        
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
    }
    
}

