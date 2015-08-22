# HYLImageGroupViewController

![demo image](https://github.com/lionhylra/HYLImageGroupViewController/blob/master/Demo/demo.gif?raw=true)

#### This is a image viewer similar to what WeChat uses to view images. It is written using swift and is compatible with objective-c. Just drop it to your project and pass images or urls to make the magic happen. Feel free to download the demo and give a try!

### Features

 - Simple to use
 - Support Objective-c and swift
 - Cache images in memory cache(NSCache) and in file system
 - Double tap to zoom in and zoom out
 - Single tap to close the image viewer

### Install
#####1. CocoaPods
(nod ready, coming soon)
#####2. Drop in
**For Swift**

 - Just drop the "HYLImageGroupViewController" folder into your project.

**For Objective-c**

 - Drop the "HYLImageGroupViewController" folder into your project. 
 - Import the swift header file in the .m file which you would like to use this
```objective-c
 #import "YourProjectName-Swift.h"
```
 
### How to use (API)
**Swift:**
```swift
let myImages:[UIImage]
let viewController = HYLImageGoupViewController(images:myImages)
//in the view controller
self.presentViewController(viewController, animated: true, completion: nil)
```
You can also init it with image urls:
```swift
let urls:[NSURL]
let thumbnails:[UIImage]
let viewContrller = HYLImageGroupViewController(imageURLs: urlGroup, placeHolderImages: thumbnails)
```
Or you can init it with an array of url strings:
```swift
let urlStrings:[String]
//thumbnail could be nil
let viewController = HYLImageGroupViewController(imageURLStrings: urlStrings, placeHolderImages: nil)
```
You can specify the start page after initializing the view controller:
```swift
viewController.currentPage = 2//it will open from the third image
```
**Objective-c**
Same API, just the code style is changed
```objective-c
HYLImageGroupViewController *vc = [[HYLImageGroupViewController alloc] initWithImageURLs:urls placeHolderImages:placeholder];
vc.currentPage = 2
[self presentViewController:vc animated:YES completion:nil];
```

###What's behind the scene
The HYLImageViewController only load three images one time: the current image on screen, the image before and the image after.  Everytime user scroll the scroll view, when page changes, it updates the scroll view's subview.

When load images from url, it check the image in the memory cache(NSCache) first, if image is not found, then it check local file system. If the image is not found in cache, it downloads it and save it to local file and cache. It uses image url as the key in the cache storage and uses url's MD5 code as local file name.
### Contact Author
email: lionhylra@gmail.com
website: lionhylra.com
### Support Author?
![WeChat Pay QR code](https://github.com/lionhylra/HYLImageGroupViewController/blob/master/donate.jpg?raw=true)
