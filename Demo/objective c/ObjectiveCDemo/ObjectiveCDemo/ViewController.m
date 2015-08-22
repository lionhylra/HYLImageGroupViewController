//
//  ViewController.m
//  ObjectiveCDemo
//
//  Created by HeYilei on 22/08/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

#import "ViewController.h"
#import "ObjectiveCDemo-Swift.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)openSingleImage:(id)sender {
    UIViewController *vc = [[HYLImageGroupViewController alloc] initWithImages:@[[UIImage imageNamed:@"img1"]]];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)openMultipleImages:(id)sender {
    HYLImageGroupViewController *vc = [[HYLImageGroupViewController alloc] initWithImages:@[[UIImage imageNamed:@"img1"], [UIImage imageNamed:@"img2"], [UIImage imageNamed:@"img3"], [UIImage imageNamed:@"img4"], [UIImage imageNamed:@"img5"], [UIImage imageNamed:@"img6"]]];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
    vc.currentPage = ((UIView *)sender).tag;
}

- (IBAction)openMultipleURLs:(id)sender{
    NSArray *urls = @[
                      [NSURL URLWithString:@"https://farm1.staticflickr.com/649/20718255592_b9ae2c78a3_b.jpg"],
                      [NSURL URLWithString:@"https://farm1.staticflickr.com/741/20730241532_2cbacb377c_b.jpg"],
                      [NSURL URLWithString:@"https://farm6.staticflickr.com/5730/20735277275_06179836e2_b.jpg"],
                      [NSURL URLWithString:@"https://farm6.staticflickr.com/5775/20747091191_df05888526_b.jpg"],
                      [NSURL URLWithString:@"https://farm1.staticflickr.com/708/20730188882_700d004af1_b.jpg"],
                      [NSURL URLWithString:@"https://farm1.staticflickr.com/709/20734995351_45e5e80b9f_b.jpg"]
                      ];
    NSArray *placeholder = @[[UIImage imageNamed:@"thumb1"], [UIImage imageNamed:@"thumb2"], [UIImage imageNamed:@"thumb3"], [UIImage imageNamed:@"thumb4"], [UIImage imageNamed:@"thumb5"], [UIImage imageNamed:@"thumb6"]];
    HYLImageGroupViewController *vc = [[HYLImageGroupViewController alloc] initWithImageURLs:urls placeHolderImages:placeholder];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)openMultipleURLStrings:(id)sender{
    NSArray *urls = @[
                      @"https://farm1.staticflickr.com/649/20718255592_b9ae2c78a3_b.jpg",
                      @"https://farm1.staticflickr.com/741/20730241532_2cbacb377c_b.jpg",
                      @"https://farm6.staticflickr.com/5730/20735277275_06179836e2_b.jpg",
                      @"https://farm6.staticflickr.com/5775/20747091191_df05888526_b.jpg",
                      @"https://farm1.staticflickr.com/708/20730188882_700d004af1_b.jpg",
                      @"https://farm1.staticflickr.com/709/20734995351_45e5e80b9f_b.jpg"
                      ];
    HYLImageGroupViewController *vc = [[HYLImageGroupViewController alloc] initWithImageURLStrings:urls placeHolderImages:nil];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
