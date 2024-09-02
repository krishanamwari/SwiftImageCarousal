//
//  ViewController.swift
//  SwiftImageCarousal
//
//  Created by Krishana Maheshwari on 02/09/24.
//

import UIKit

//["Dummy1", "Dummy2", "Dummy3", "Dummy4", "Dummy5"]

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define the images you want to display in the carousel
        let images = ["Dummy1", "Dummy2", "Dummy3", "Dummy4", "Dummy5"]
        // Create an instance of ZoomingCarouselView
        let carouselView = ZoomingCarouselView(frame: CGRect(x: 0, y: 200, width: view.frame.size.width, height: 400), images: images)
        
        // Add the carousel view to the view controller's view
        view.addSubview(carouselView)
    }
}
