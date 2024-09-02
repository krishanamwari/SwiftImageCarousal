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
    
    let carouselView = ZoomingCarouselView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an instance of ZoomingCarouselView
        let topView = UIView()
        topView.backgroundColor = .lightGray
        
        let bottomView = UIView()
        bottomView.backgroundColor = .gray
        // Add the carousel view to the view controller's view
        view.addSubview(topView)
        view.addSubview(carouselView)
        view.addSubview(bottomView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        carouselView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        carouselView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        carouselView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
        
    }
    
    override func viewDidLayoutSubviews() {
        // Define the images you want to display in the carousel
        let images = ["Dummy1", "Dummy2", "Dummy3", "Dummy4", "Dummy5"]
        carouselView.setData(images: images)
    }
}
