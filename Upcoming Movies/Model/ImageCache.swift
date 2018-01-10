//
//  ImageCache.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 10/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

enum ImageSize : String {
    case low
    case medium
    case high
    case original
}

class ImageLoader: UIImageView {
    
    var imageURL: URL?
    
    let activityIndicator = UIActivityIndicatorView()
    
    func loadImage(forMovie movie : Movie, andType type : ImageType, andSize size : String) {
        
        let anypath = (type == .poster ? movie.poster_path : movie.backdrop_path)
        
        guard let path = anypath, let posterURL = URL(string : "https://image.tmdb.org/t/p/\(size)\(path)") else { return }
        
        DispatchQueue.main.async {
            // setup activityIndicator...
            self.activityIndicator.color = .orange
            
            self.addSubview(self.activityIndicator)
            self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
        }
        
        imageURL = posterURL
        
        image = nil
        activityIndicator.startAnimating()
        
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: posterURL as AnyObject) as? UIImage {
            
            self.image = imageFromCache
            self.alpha = 1
            activityIndicator.stopAnimating()
            return
        }
        
        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: posterURL, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    
                    if self.imageURL == posterURL {
                        self.image = imageToCache
                        UIView.animate(withDuration: 0.5, animations: {
                            self.alpha = 1
                        })
                    }
                    
                    imageCache.setObject(imageToCache, forKey: posterURL as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
        
    }
    
}
