//
//  loaderView.h
//  Sunburn
//
//  Created by binit on 26/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RTSpinKitView.h>

@interface loaderView : UIView

@property RTSpinKitView * spinner;

-(void)stopAnimating;
-(void)startAnimating;
@end
