//
//  HYLImageCachedDownloader.swift
//  HYLImageViewController
//
//  Created by HeYilei on 21/08/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

import UIKit

public typealias ProgressBlock = ((receivedSize: Int64, totalSize: Int64) -> ())
public typealias CompletionBlock = ((image:UIImage?, error:NSError?, imageURL:NSURL?)->())

protocol HYLImageMemoryCache {
    func cachedImageForURL(url:NSURL) -> UIImage?
    func cacheImage(image:UIImage, withURL url:NSURL)
}

protocol HYLImageFileCache{
    func retrieveImageForURL(url:NSURL) -> UIImage?
}

func synchronizd(lock: AnyObject, closure:()->()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock);
}

class ImageCache:NSCache,HYLImageMemoryCache{
    func cachedImageForURL(url: NSURL) -> UIImage? {
        if let key = url.absoluteString{
            return self.objectForKey(key) as? UIImage
        }
        
        return nil
    }
    
    func cacheImage(image: UIImage, withURL url: NSURL) {
        if let key = url.absoluteString{
            self.setObject(image, forKey: key)
        }
    }
    
}

public class ImageDownloader: NSObject,NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate, HYLImageFileCache{
    // MARK: - Properties
    lazy private var downloadSession:NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        }()
    
    lazy private var imageManager = HYLImageManager(directory: NSSearchPathDirectory.CachesDirectory, pathComponents: ["com.HYLMultiImagesViewController.Caches"])
    static private let imageCache = {()->ImageCache in
        let cache = ImageCache()
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidReceiveMemoryWarningNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
            cache.removeAllObjects()
        })
        return cache
    }()
    private var downloadingURLsList = NSMutableArray()//track the downloading tasks
    var progressBlock:ProgressBlock?
    var completionBlock:CompletionBlock?
    // MARK: - init
    convenience init(progressBlock: ProgressBlock?, completionBlock:CompletionBlock?){
        self.init()
        self.progressBlock = progressBlock
        self.completionBlock = completionBlock
    }
    
    // MARK: - retrieve image methods
    public func fileNameForURL(url:NSURL) -> String?{
        if let urlStr = url.absoluteString {
            return urlStr.kf_MD5()
        }
        return nil
    }
    
    public func retrieveImageForURL(url:NSURL) -> UIImage?{
        if let fileName = self.fileNameForURL(url) {
            if let image = ImageDownloader.imageCache.cachedImageForURL(url) {
                return image
            }else if let image = self.imageManager.imageWithName(fileName) {
                ImageDownloader.imageCache.cacheImage(image, withURL: url)
                return image
            }else{
                self.downloadFileWithURL(url)
                return nil
            }
        }
        return nil
    }
    
    private func downloadFileWithURL(url:NSURL){
        if self.downloadingURLsList.containsObject(url){
            return
        }else{
            let task = self.downloadSession.downloadTaskWithURL(url)
            task.resume()
            self.downloadingURLsList.addObject(url)
        }
    }
    
    // MARK: - NSURLSessionDownloadDelegate
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        /* get the destination */
        let destinationPath:String
        let destinationURL:NSURL
        if let url = downloadTask.originalRequest.URL, fileName = self.fileNameForURL(url) {
            destinationPath = self.imageManager.pathForImageName(fileName)!
            destinationURL = NSURL(fileURLWithPath: destinationPath)!
        }else{
            return
        }
        
        /* move file to destination */
        var error:NSError?
        var isDir = ObjCBool(false)
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(destinationPath) {
            fileManager.replaceItemAtURL(destinationURL, withItemAtURL: location, backupItemName: nil, options: NSFileManagerItemReplacementOptions.UsingNewMetadataOnly, resultingItemURL: nil, error: &error)
        }else{
            if !fileManager.fileExistsAtPath(destinationPath.stringByDeletingLastPathComponent, isDirectory: &isDir) || !isDir {
            
                fileManager.createDirectoryAtPath(destinationPath.stringByDeletingLastPathComponent, withIntermediateDirectories: true, attributes: nil, error: &error)
            
            }
            fileManager.moveItemAtURL(location, toURL: destinationURL, error: &error)
        }
        if error != nil {
            println("Move downloaded file to destination \"\(destinationPath)\" failed with error: \(error!.description)")
        }
        
    }
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let progressHandler = self.progressBlock {
            progressHandler(receivedSize: totalBytesWritten, totalSize: totalBytesExpectedToWrite)
        }
    }
    
    // MARK: - NSURLSessionTaskDelegate
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let completionHandler = self.completionBlock {
            var image:UIImage? = nil
            if let url = task.originalRequest.URL, let fileName = self.fileNameForURL(url) {
                image = self.imageManager.imageWithName(fileName)
                ImageDownloader.imageCache.cacheImage(image!, withURL: url)
                completionHandler(image: image, error: error, imageURL: url)
            }else{
                completionHandler(image: nil, error: error, imageURL: nil)
            }
        }
        /* remove from track list */
        synchronizd(self) {
            if let url = task.originalRequest.URL {
                self.downloadingURLsList.removeObject(url)
            }
        }
    }
}
