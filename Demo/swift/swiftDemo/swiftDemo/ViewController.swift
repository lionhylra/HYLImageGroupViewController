//
//  ViewController.swift
//  HYLImageGroupViewControllerDemo
//
//  Created by HeYilei on 22/08/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let aImage = UIImage(named: "img1")!
    let imageGroup = [UIImage(named: "img1")!, UIImage(named: "img2")!, UIImage(named: "img3")!, UIImage(named: "img4")!, UIImage(named: "img5")!, UIImage(named: "img6")!]
    let thumbnailGroup = [UIImage(named: "thumb1")!, UIImage(named: "thumb2")!, UIImage(named: "thumb3")!, UIImage(named: "thumb4")!, UIImage(named: "thumb5")!, UIImage(named: "thumb6")!]
    let urlGroup = [
        NSURL(string:"https://farm1.staticflickr.com/649/20718255592_b9ae2c78a3_b.jpg")!,
        NSURL(string:"https://farm1.staticflickr.com/741/20730241532_2cbacb377c_b.jpg")!,
        NSURL(string:"https://farm6.staticflickr.com/5730/20735277275_06179836e2_b.jpg")!,
        NSURL(string:"https://farm6.staticflickr.com/5775/20747091191_df05888526_b.jpg")!,
        NSURL(string:"https://farm1.staticflickr.com/708/20730188882_700d004af1_b.jpg")!,
        NSURL(string:"https://farm1.staticflickr.com/709/20734995351_45e5e80b9f_b.jpg")!
    ]
    
    let urlStringGroup = [
        "https://farm1.staticflickr.com/649/20718255592_b9ae2c78a3_b.jpg",
        "https://farm1.staticflickr.com/741/20730241532_2cbacb377c_b.jpg",
        "https://farm6.staticflickr.com/5730/20735277275_06179836e2_b.jpg",
        "https://farm6.staticflickr.com/5775/20747091191_df05888526_b.jpg",
        "https://farm1.staticflickr.com/708/20730188882_700d004af1_b.jpg",
        "https://farm1.staticflickr.com/709/20734995351_45e5e80b9f_b.jpg"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openSingleImage(){
        let vc = HYLImageGroupViewController(images: [aImage])
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func openMultipleImages(button:UIButton){
        
        let vc = HYLImageGroupViewController(images: imageGroup)
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
        
        vc.currentPage = button.tag
        
    }
    
    @IBAction func openMultipleURLs(){
        let vc = HYLImageGroupViewController(imageURLs: urlGroup, placeHolderImages: thumbnailGroup)
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func openMultipleURLStrings(){
        let vc = HYLImageGroupViewController(imageURLStrings: urlStringGroup, placeHolderImages: nil)
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
