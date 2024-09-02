//
//  ZoomingCarouselView.swift
//  SwiftImageCarousal
//
//  Created by Krishana Maheshwari on 02/09/24.
//
import UIKit

class ZoomingCarouselView: UIView, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    private var images: [String] = []
    private var imageViews: [UIImageView] = []
    
    // Initializer to set up the carousel
    init(frame: CGRect, images: [String]) {
        self.images = images
        super.init(frame: frame)
        
        setupScrollView()
        setupPageControl()
        updateImageViewScales()
        
        scrollToMiddleImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupScrollView() {
        // Configure ScrollView
        scrollView.frame = bounds
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        addSubview(scrollView)
        
        let imageWidth: CGFloat = bounds.size.width * 0.75
        let imageHeight: CGFloat = imageWidth // Square images
        
        // Add images to ScrollView
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.image = UIImage(named: images[i])
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            let xPos = CGFloat(i) * imageWidth
            imageView.frame = CGRect(x: xPos, y: (bounds.size.height - imageHeight) / 2, width: imageWidth, height: imageHeight)
            
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
        
        let totalWidth = imageWidth * CGFloat(images.count)
        scrollView.contentSize = CGSize(width: totalWidth, height: bounds.size.height)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: (bounds.size.width - imageWidth) / 2, bottom: 0, right: (bounds.size.width - imageWidth) / 2)
    }
    
    private func setupPageControl() {
        // Configure PageControl
        pageControl.numberOfPages = images.count
        pageControl.currentPage = images.count / 2  // Start with the middle image
        pageControl.tintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        
        // Center the page control
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func updateImageViewScales() {
        let centerX = scrollView.contentOffset.x + scrollView.frame.size.width / 2
        
        for imageView in imageViews {
            let offset = abs(centerX - imageView.center.x)
            let scale = max(1 - offset / scrollView.frame.size.width, 0.75)
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    private func snapToNearestImage() {
        let imageWidth: CGFloat = bounds.size.width * 0.75
        let offsetX = scrollView.contentOffset.x + scrollView.contentInset.left
        
        let index = round(offsetX / imageWidth)
        let targetX = index * imageWidth - scrollView.contentInset.left
        
        scrollView.setContentOffset(CGPoint(x: targetX, y: scrollView.contentOffset.y), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateImageViewScales()
        
        let imageWidth: CGFloat = bounds.size.width * 0.75
        let pageIndex = round(scrollView.contentOffset.x / imageWidth)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let imageWidth: CGFloat = bounds.size.width * 0.75
        let offsetX = scrollView.contentOffset.x + scrollView.contentInset.left
        
        let index: CGFloat
        if velocity.x > 0 {
            index = ceil(offsetX / imageWidth)
        } else if velocity.x < 0 {
            index = floor(offsetX / imageWidth)
        } else {
            index = round(offsetX / imageWidth)
        }
        
        let targetX = index * imageWidth - scrollView.contentInset.left
        
        scrollView.setContentOffset(CGPoint(x: targetX, y: scrollView.contentOffset.y), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToNearestImage()
    }
    
    private func scrollToMiddleImage() {
        let imageWidth: CGFloat = bounds.size.width * 0.75
        let middleIndex = CGFloat(images.count / 2)
        let targetX = middleIndex * imageWidth - scrollView.contentInset.left
        
        scrollView.setContentOffset(CGPoint(x: targetX, y: scrollView.contentOffset.y), animated: false)
        updateImageViewScales()
    }
}
