//
//  DrawerCategoryCell.m
//  Sunburn
//
//  Created by binit on 31/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "DrawerCategoryCell.h"

@implementation DrawerCategoryCell

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:28.0f/255.0f green:38.0f/255.0f blue:48.0f/255.0f alpha:0.8f];
    UIView * bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor =[UIColor colorWithRed:28.0f/255.0f green:38.0f/255.0f blue:48.0f/255.0f  alpha:0.8f];
    self.selectedBackgroundView = bgView;
    
    _label_CategoryName.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f  alpha:1.0f];
}
@end
