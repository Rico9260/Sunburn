//
//  HomeGridSmallCell.m
//  Sunburn
//
//  Created by binit on 03/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "HomeGridSmallCell.h"

@implementation HomeGridSmallCell

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _view_ProductDetails.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.0] CGColor], (id)[[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.5] CGColor], nil];
    [_view_ProductDetails.layer insertSublayer:gradient atIndex:0];
//    gradient.frame = [_btnMore bounds];
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3] CGColor], (id)[[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.0] CGColor], nil];
//    [_btnMore.layer addSublayer:gradient];
}


@end
