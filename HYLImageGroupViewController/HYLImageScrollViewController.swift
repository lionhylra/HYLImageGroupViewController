//
//  HYLImageScrollViewController.swift
//  HYLImageViewController
//
//  Created by HeYilei on 19/08/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

import UIKit
//import Kingfisher

public class HYLImageScrollViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Private Properties
    private let maskView = UIView()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    private let errorLabel = UILabel()
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private var image:UIImage?
    private var imageURL:NSURL?
    
    // MARK: - Initializers
    convenience init(image:UIImage){
        self.init()
        self.image = image
    }
    
    convenience init(imageURL:NSURL, placeholderImage:UIImage?){
        self.init()
        self.imageURL = imageURL
        if let placeholder = placeholderImage {
            self.image = placeholder
        }
    }
    
    //MARK: - UIViewController Life Circle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        /* prepare subViews */
        layoutSubViews()
        addSubViews()
        
        /* configure subViews */
        configureImageView()
        configureScrollView()
        if self.imageURL != nil {
            configureLoadingMask()
        }
        configureErrorLabel()
        
        /* gesture */
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        /* position */
        centerScrollViewContents()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIScrollViewDelegate
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    // MARK: - Event Response
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        if self.scrollView.zoomScale == self.scrollView.maximumZoomScale {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        }else{
            
            // 1
            let pointInView = recognizer.locationInView(imageView)
            
            /*
            // 2
            var newZoomScale = scrollView.maximumZoomScale
            
            // 3
            let scrollViewSize = scrollView.bounds.size
            let w = scrollViewSize.width / newZoomScale
            let h = scrollViewSize.height / newZoomScale
            let x = pointInView.x - (w / 2.0)
            let y = pointInView.y - (h / 2.0)
            
            //let rectToZoomTo = CGRectMake(x, y, w, h)
            */
            
            let rectToZoomTo = CGRectMake(pointInView.x, pointInView.y, 10.0, 10.0)
            
            // 4
            scrollView.zoomToRect(rectToZoomTo, animated: true)
        }
    }

    
    // MARK: - Private Methods
    private func layoutSubViews(){
        /* scrollView */
        self.scrollView.frame = CGRect(origin: CGPointZero, size: self.view.frame.size)
        /* imageView */
        if let imageSize = self.image?.size {
            self.imageView.frame = CGRect(origin: CGPointZero, size: imageSize)
        }else{
            self.imageView.frame = CGRect(origin: CGPointZero, size: self.scrollView.frame.size)
        }
        
        /* errorLabel */
        self.errorLabel.frame.size.width = self.view.bounds.size.width * 0.8
    }
    
    private func addSubViews(){
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        
        self.view.addSubview(self.maskView)
        self.maskView.addSubview(self.activityIndicator)
        
        self.view.addSubview(self.errorLabel)
    }
    
    private func configureScrollView(){
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.scrollView.pagingEnabled = false
        if let imageSize = self.image?.size {
            self.scrollView.contentSize = imageSize
        }else{
            self.scrollView.contentSize = self.scrollView.bounds.size
        }
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        
        /* configure zoomScale */
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
    }
    
    private func configureImageView(){
        if self.imageURL != nil{
//            self.imageView.kf_setImageWithURL(self.imageURL!, placeholderImage: self.image, optionsInfo: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
//                self.image = image
//                if let imageSize = self.image?.size {
//                    self.imageView.frame = CGRect(origin: CGPointZero, size: imageSize)
//                }
//                self.configureScrollView()
//                self.loadingDidComplete()
//            })
            self.imageView.setImageWithURL(self.imageURL!, placeholderImage: self.image, completionBlock: { (image, error, imageURL) -> () in
                self.image = image
                if let imageSize = self.image?.size {
                    self.imageView.frame = CGRect(origin: CGPointZero, size: imageSize)
                    self.configureScrollView()
                    self.loadingDidComplete()
                }
                if error != nil {
                    self.loadingDidComplete()
                    self.errorLabel.hidden = false
                    self.errorLabel.text = "Error: " + error!.localizedDescription
                    
                    /* configure size of errorLabel */
                    self.errorLabel.sizeToFit()
                    var frame = self.errorLabel.frame
                    frame.origin.x = self.view.bounds.size.width / 2 - frame.width / 2
                    frame.origin.y = self.view.bounds.size.height / 2 - frame.height / 2
                    self.errorLabel.frame = frame
                    self.view.bringSubviewToFront(self.errorLabel)
                }
            })
        }else{
            self.imageView.image = self.image
        }
    }
    
    private func configureLoadingMask(){
        self.maskView.backgroundColor = UIColor.blackColor()
        self.maskView.alpha = 0.7
        self.maskView.frame = self.view.bounds
        self.activityIndicator.hidesWhenStopped = true
        var frame = self.activityIndicator.frame
        frame.origin.x = (maskView.bounds.size.width - activityIndicator.bounds.width)/2
        frame.origin.y = (maskView.bounds.size.height - activityIndicator.bounds.height)/2
        self.activityIndicator.frame = frame
        self.activityIndicator.startAnimating()
    }
    
    private func configureErrorLabel(){
        self.errorLabel.text = "Error!"
        self.errorLabel.numberOfLines = 0
        self.errorLabel.backgroundColor = UIColor.blackColor()
        self.errorLabel.textColor = UIColor.whiteColor()
        self.errorLabel.hidden = true
    }
    
    private func loadingDidComplete(){
        self.maskView.hidden = true
        self.activityIndicator.stopAnimating()
    }
    
    private func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
        
    }
    
}
