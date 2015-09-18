//
//  HYLImageGroupViewController.swift
//  HYLImageGroupViewController
//
//  Created by HeYilei on 18/08/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

import UIKit


let kPageInterval:CGFloat = 20.0
let kPageSize:CGSize = UIScreen.mainScreen().bounds.size

public class HYLImageGroupViewController: UIViewController, UIScrollViewDelegate {
    //MARK: - Private Properties
    private let scrollView:UIScrollView = UIScrollView()
    private let pageControl:UIPageControl = UIPageControl()
    private var images:[UIImage]?
    private var imageURLs:[NSURL]?
    
    // MARK: - Public Properties
    public var currentPage:Int = 0 {
        didSet{
            if currentPage >= imagesCount{
                currentPage = imagesCount - 1
            }
            if currentPage < 0 {
                currentPage = 0
            }
        }
    }
    var imagesCount:Int {
        if self.imageURLs != nil{
            return self.imageURLs!.count
        }
        
        if self.images != nil {
            return self.images!.count
        }
        return 0
    }
    
    //MARK: - Initialization
    public convenience init(images:[UIImage]){
        self.init()
        self.images = images
    }
    
    public convenience init(imageURLs:[NSURL], placeHolderImages:[UIImage]?){
        self.init()
        self.imageURLs = imageURLs
        if let placeHolders = placeHolderImages {
            self.images = placeHolders
        }
    }
    
    public convenience init(imageURLStrings:[String], placeHolderImages:[UIImage]?){
        var urls = [NSURL]()
        for str in imageURLStrings {
            if let url = NSURL(string: str) where url.host != nil {
                urls.append(url)
            }
        }
        self.init(imageURLs: urls, placeHolderImages: placeHolderImages)
    }
    
    //MARK: - UIViewController Life Circle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        /* prepare subViews */
        addSubViews()
        layoutSubviews()
        
        /* configure subViews */
        configurePageControl()
        configureScrollView()
        
        /* gesture */
        let tap = UITapGestureRecognizer(target: self, action: "didTapOnView")
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(doubleTap)
        tap.requireGestureRecognizerToFail(doubleTap)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollView.contentOffset.x = (kPageSize.width + kPageInterval) * CGFloat(self.currentPage)
        self.loadVisiblePages()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override public func prefersStatusBarHidden() -> Bool {
        return true
    }
        
    // MARK: - Event Response
    func didTapOnView(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        /* determine which page is currently visible */
        let pageWidth = kPageSize.width + kPageInterval//this is different from kPageSize
        let position = self.scrollView.contentOffset.x / pageWidth
        let newPage = lroundf(Float(position))
        let positionInPage = (self.scrollView.contentOffset.x % pageWidth)/pageWidth//This is for improve user experience, to delay the update of the image
        if (newPage != self.currentPage) && ( positionInPage < 0.05 || positionInPage > 0.95){
            self.currentPage = newPage
            self.loadVisiblePages()
        }
    }
    
    // MARK: - Private Methods
    private func addSubViews(){
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.pageControl)
    }
    
    private func layoutSubviews(){
        /* scrollView */
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        let topEdgeConstraint = NSLayoutConstraint(item: self.scrollView, attribute: .Top , relatedBy: .Equal, toItem: self.view, attribute: .Top , multiplier: 1.0, constant: 0.0)
        let leftEdgeConstraint = NSLayoutConstraint(item: self.scrollView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let bottomEdgeConstraint = NSLayoutConstraint(item: self.scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let rightEdgeConstraint = NSLayoutConstraint(item: self.scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: kPageInterval)
        self.view.addConstraint(topEdgeConstraint)
        self.view.addConstraint(leftEdgeConstraint)
        self.view.addConstraint(bottomEdgeConstraint)
        self.view.addConstraint(rightEdgeConstraint)
        
        /* pageControl */
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        let bottomEdgeConstraint_pageControl = NSLayoutConstraint(item: self.pageControl, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -35.0)
        let centerXConstraint = NSLayoutConstraint(item: self.pageControl, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(bottomEdgeConstraint_pageControl)
        self.view.addConstraint(centerXConstraint)
    }
    
    private func configurePageControl(){
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = self.imagesCount
        self.pageControl.hidesForSinglePage = true
        
    }
    
    private func configureScrollView(){
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = UIColor.blackColor()
        self.scrollView.pagingEnabled = true
        self.scrollView.contentSize = CGSizeMake((kPageSize.width+kPageInterval) * CGFloat(self.imagesCount), kPageSize.height)
    }
    
    private func loadVisiblePages(){
        let page = self.currentPage
        let previousPage = page - 1
        let nextPage = page + 1
        
        /* Update page control */
        self.pageControl.currentPage = page
        
        /* load pages */
        loadPage(prev: previousPage, currentPage: page, next: nextPage)
        
    }
    
    private func loadPage(prev prev:Int, currentPage:Int, next:Int){
        /* clear views */
        for viewController in self.childViewControllers {
            viewController.removeFromParentViewController()
            viewController.view?.removeFromSuperview()
        }
    
        
        
        func addPage(page:Int){
            /* check page availability */
            if page < 0 || page >= self.imagesCount {
                return
            }
            
            /* prepare frame */
            let frame = CGRectMake((kPageSize.width + kPageInterval) * CGFloat(page), 0, kPageSize.width, kPageSize.height)

            
            if self.imageURLs != nil {
                let subViewController = HYLImageScrollViewController(imageURL: self.imageURLs![page], placeholderImage: self.images?[page])
                subViewController.view.frame = frame
                self.scrollView.addSubview(subViewController.view)
                self.addChildViewController(subViewController)
                return
            }
            /* create image view */
            if let img = self.images?[page] {
                /*
                /* non-zoom version */
                let imageView = UIImageView(image: img)
                imageView.contentMode = .ScaleAspectFit
                imageView.frame = frame
                self.scrollView.addSubview(imageView)
                */
                let subViewController = HYLImageScrollViewController(image: img)
                subViewController.view.frame = frame
                self.scrollView.addSubview(subViewController.view)
                self.addChildViewController(subViewController)

            }
            
            
            
        }
        
        addPage(prev)
        addPage(currentPage)
        addPage(next)
    }

}
