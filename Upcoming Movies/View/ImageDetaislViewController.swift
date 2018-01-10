//
//  ImageDetaislViewController.swift
//  Upcoming Movies
//
//  Created by Alan Rabelo Martins on 10/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class ImageDetaislViewController: UIViewController, UIScrollViewDelegate {

    var image : UIImage?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        self.imageView.image = image
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Gets the y Scrollview offset
        let yOffset = scrollView.contentOffset.y
        
        // Dismiss view if slides down
        if yOffset < -100 {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
