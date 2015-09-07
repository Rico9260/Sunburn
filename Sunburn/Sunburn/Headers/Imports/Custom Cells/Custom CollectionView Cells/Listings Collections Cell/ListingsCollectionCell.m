//
//  ListingsCollectionCell.m
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "ListingsCollectionCell.h"

@implementation ListingsCollectionCell
-(void)awakeFromNib{
    
    [super awakeFromNib];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _viewProductInfo.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.0] CGColor], (id)[[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.5] CGColor], nil];
    [_viewProductInfo.layer insertSublayer:gradient atIndex:0];
}

@end
