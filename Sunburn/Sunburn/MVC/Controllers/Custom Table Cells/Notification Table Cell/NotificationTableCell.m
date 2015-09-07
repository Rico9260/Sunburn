//
//  NotificationTableCell.m
//  Sunburn
//
//  Created by binit on 03/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "NotificationTableCell.h"

@implementation NotificationTableCell

-(void)awakeFromNib{
    
    [super awakeFromNib];
    UIView * bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor =[UIColor colorWithRed:33.0f/255.0f green:43.0f/255.0f blue:56.0f/255.0f alpha:1];
    self.selectedBackgroundView = bgView;
}
@end
