//
//  CustomSlider.m
//  Sunburn
//
//  Created by binit on 06/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "CustomSlider.h"

@implementation CustomSlider

-(void)awakeFromNib{
    
    [super awakeFromNib];
//    [self setThumbTintColor:[UIColor clearColor]];
    [self setClipsToBounds:YES];
}

- (CGRect)trackRectForBounds:(CGRect)bounds{
    
    return CGRectMake(0
                      , 0, bounds.size.width, 10);
}

//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
//    
//    return CGRectMake(bounds.origin.x
//                      , bounds.origin.y, bounds.size.width, bounds.size.height);
//}

@end
