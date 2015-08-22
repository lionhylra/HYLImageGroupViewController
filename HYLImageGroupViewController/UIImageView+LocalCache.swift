//
//  UIImageView+LocalCache.swift
//  HYLImageViewController
//
//  Created by HeYilei on 20/08/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

import UIKit


extension UIImageView {
    
    func setImageWithURL(url:NSURL){
        setImageWithURL(url, placeholderImage: nil)
    }
    
    func setImageWithURL(url:NSURL, placeholderImage: UIImage?){
        setImageWithURL(url, placeholderImage: placeholderImage, completionBlock: nil)
    }
    
    func setImageWithURL(url:NSURL, placeholderImage: UIImage?, completionBlock:CompletionBlock?){
        setImageWithURL(url, placeholderImage: placeholderImage, progressBlock: nil, completionBlock: completionBlock)
    }
    
    func setImageWithURL(url:NSURL, placeholderImage: UIImage?, progressBlock:ProgressBlock?,completionBlock:CompletionBlock?){
        /* if the image is cached */
        let imageDownloader = HYLImageDownloader(progressBlock: progressBlock) {[unowned self] (image, error, imageURL) -> () in
            self.image = image
            if let completionHandler = completionBlock {
                completionHandler(image: image, error: error, imageURL: imageURL)
            }
        }
        if let image = imageDownloader.retrieveImageForURL(url) {
            self.image = image
            if let completionHandler = completionBlock {
                completionHandler(image: image, error: nil, imageURL: url)
            }
            return
        }
        
        /* if the image is NOT cached */
        self.image = placeholderImage
        
    }
    
    
}



