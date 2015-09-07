//
//  SidePanelTableViewCell.m
//  Foodi
//
//  Created by Rajat Sharma on 28/06/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import "SidePanelTableViewCell.h"

@implementation SidePanelTableViewCell

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    UIView * bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor =[UIColor clearColor];
    self.selectedBackgroundView = bgView;
    
    _Label_name.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f  alpha:1.0f];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
