import UIKit

class ZoomingCarouselView: UIView, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    private var images: [String] = []
    private var imageViews: [UIImageView] = []
    
    private let minScale: CGFloat = 0.75 // Inverse zooming factor of centre tile, 0 < value < 1
    private var imageScaleFactor: CGFloat = 0.60 // Adjust this to scale the size of image with ratio to width of view
    private let cornerRadius: CGFloat = 15.0  // Adjust corner radius as needed
    
    // Initializer to set up the carousel
    init(frame: CGRect, images: [String]) {
        super.init(frame: frame)
        setData(images: images)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(images: [String]) {
        self.images = images
        setupScrollView()
        setupPageControl()
        updateImageViewScales()
        
        scrollToMiddleImage()
    }
    
    private func setupScrollView() {
        // Configure ScrollView
        scrollView.frame = bounds
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false // Disable bounce effect
        scrollView.delegate = self
        
        addSubview(scrollView)
        
        var imageWidth: CGFloat = bounds.size.width * imageScaleFactor
        
        
        let height = bounds.size.height
        let maxBreadthMinHeight = bounds.size.width * imageScaleFactor / minScale + 35
        if maxBreadthMinHeight > height {
            imageWidth = (height - 35) * minScale
            imageScaleFactor = imageWidth / bounds.size.width
        }
        let imageHeight: CGFloat = imageWidth // Square images
        
        // Add images to ScrollView
        for i in 0..<images.count {
            let containerView = UIView()
            let imageView = UIImageView()
            imageView.image = UIImage(named: images[i])
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = cornerRadius  // Set rounded corners
            
            let xPos = CGFloat(i) * imageWidth
            containerView.frame = CGRect(x: xPos, y: (((1/minScale) - 1)*imageHeight)/2, width: imageWidth, height: imageHeight)
            imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
            scrollView.addSubview(containerView)
            containerView.addSubview(imageView)
            imageViews.append(imageView)
        }
        
        // Calculate total width considering zoom effect
        let totalWidth = imageWidth * CGFloat(images.count)
        scrollView.contentSize = CGSize(width: totalWidth, height: bounds.size.height)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: (bounds.size.width - imageWidth) / 2, bottom: 0, right: (bounds.size.width - imageWidth) / 2)
    }
    
    private func setupPageControl() {
        // Configure PageControl
        pageControl.numberOfPages = images.count
        pageControl.currentPage = images.count / 2  // Start with the middle image
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? .white : .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        
        // Center the page control
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateImageViewScales() {
        let centerX = scrollView.contentOffset.x + scrollView.frame.size.width / 2
        
        var maxZoomScale = 0.0
        var maxScaleIndex = 0
        for (i,imageView) in imageViews.enumerated() {
            let offset = abs(centerX - (imageView.superview?.center.x ?? 0))
            let scale = max(1 - offset / scrollView.frame.size.width, minScale)
            let zoomScale = scale / minScale
            imageView.transform = CGAffineTransform(scaleX: zoomScale, y: zoomScale)
            print(maxZoomScale,zoomScale)
            if maxZoomScale <= zoomScale {
                maxZoomScale = zoomScale
                maxScaleIndex = i
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.pageControl.currentPage = Int(maxScaleIndex)
            guard let containerView = self?.imageViews[maxScaleIndex].superview else { return }
            self?.scrollView.bringSubviewToFront(containerView)
        }
    }
    
    private func snapToNearestImage() {
        let imageWidth: CGFloat = bounds.size.width * imageScaleFactor
        let offsetX = scrollView.contentOffset.x + scrollView.contentInset.left
        
        let index = round(offsetX / imageWidth)
        let targetX = index * imageWidth - scrollView.contentInset.left
        
        scrollView.setContentOffset(CGPoint(x: targetX, y: scrollView.contentOffset.y), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateImageViewScales()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let imageWidth: CGFloat = bounds.size.width * imageScaleFactor
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
        let imageWidth: CGFloat = bounds.size.width * imageScaleFactor
        let middleIndex = CGFloat(images.count / 2)
        let targetX = middleIndex * imageWidth - scrollView.contentInset.left
        
        scrollView.setContentOffset(CGPoint(x: targetX, y: scrollView.contentOffset.y), animated: false)
        updateImageViewScales()
    }
}
