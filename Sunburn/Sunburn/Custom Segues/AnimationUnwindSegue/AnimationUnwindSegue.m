//
//  AnimationUnwindSegue.m
//  Sunburn
//
//  Created by binit on 07/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "AnimationUnwindSegue.h"
#import "Import.h"

@implementation AnimationUnwindSegue

-(void)perform{
    
LoginViewController *sourceViewController = self.sourceViewController;
EduIdViewController *destinationViewController = self.destinationViewController;

// Add view to super view temporarily
[sourceViewController.view.superview insertSubview:destinationViewController.view atIndex:0];
    
    sourceViewController.view.frame = CGRectMake(0, 0, 0, sourceViewController.view.frame.size.width);

[UIView animateWithDuration:0.5
                      delay:0.0
                    options:UIViewAnimationOptionAutoreverse
                 animations:^{
                     
                     sourceViewController.view.frame = CGRectMake(0, sourceViewController.view.frame.size.height, sourceViewController.view.frame.size.width, sourceViewController.view.frame.size.height);
                 }
                 completion:^(BOOL finished){
                     
                     destinationViewController.frostedViewController.contentViewController = sourceViewController;
                 }];
}
@end
