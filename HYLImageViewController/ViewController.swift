//
//  ViewController.swift
//  HYLImageViewController
//
//  Created by HeYilei on 18/08/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let images2 = [UIImage(named: "people1")]
    
    
    let imageURLs = [NSURL(string: "http://topwalls.net/wallpapers/2012/01/Nature-sea-scenery-travel-photography-image-768x1366.jpg"),
        NSURL(string: "http://www.menucool.com/slider/prod/image-slider-5.jpg"),
        NSURL(string: "http://herosupermarket.co.id/wp-content/uploads/2014/05/microsoft_xp_bliss_desktop_image-650x0.jpg")]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(sender:UIButton){
        let images =    [UIImage(named: "people1"), UIImage(named: "people2"),
            UIImage(named: "people3"), UIImage(named: "people4")]
        let vc =  HYLMultiImagesViewController(images: images)
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func buttonPressed2(sender:UIButton){
        let images3 = [UIImage(named: "icon1"), UIImage(named: "icon2"), UIImage(named: "icon3")]
        let vc =  HYLMultiImagesViewController(images: images3)
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func buttonPressed3(sender:UIButton){
        let images4 = [UIImage(named: "lg-1"), UIImage(named: "lg-2"), UIImage(named: "lg-3"), UIImage(named: "lg-4")]
        let vc =  HYLMultiImagesViewController(images: images4)
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func buttonPressed4(sender:UIButton){
        let images3 = [UIImage(named: "icon1"), UIImage(named: "icon2"), UIImage(named: "icon3")]
        let vc =  HYLMultiImagesViewController(imageURLs: self.imageURLs, placeHolderImages: images3)
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }

}

