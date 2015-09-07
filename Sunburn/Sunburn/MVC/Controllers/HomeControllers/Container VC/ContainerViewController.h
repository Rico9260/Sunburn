//
//  ContainerViewController.h
//  Sunburn
//
//  Created by binit on 05/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SegueIdentifierFirst @"Poster"
#define SegueIdentifierSecond @"Grid"

@interface ContainerViewController : UIViewController

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (assign, nonatomic) BOOL transitionInProgress;

-(void)swapViewControllers;
@end
