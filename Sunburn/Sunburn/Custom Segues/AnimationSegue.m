//
//  AnimationSegue.m
//  Sunburn
//
//  Created by binit on 07/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "AnimationSegue.h"
#import "Import.h"

@implementation AnimationSegue


- (void)perform {
    
    LoginViewController *sourceViewController = self.sourceViewController;
    EduIdViewController *destinationViewController = self.destinationViewController;
    
    [sourceViewController.view addSubview:destinationViewController.view];
    
//    destinationViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
    destinationViewController.view.frame = CGRectMake(0, sourceViewController.view.frame.size.height, 0, sourceViewController.view.frame.size.width);
    // Set center to start point of the button
    destinationViewController.view.center = self.originatingPoint;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                          destinationViewController.view.frame = CGRectMake(0, 0, sourceViewController.view.frame.size.width, sourceViewController.view.frame.size.height);  
                     }
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview]; // remove from temp super view
                         sourceViewController.frostedViewController.contentViewController = destinationViewController;
                     }];
}

@end
