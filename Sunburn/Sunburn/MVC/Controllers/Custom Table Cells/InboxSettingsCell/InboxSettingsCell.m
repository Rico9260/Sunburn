//
//  InboxSettingsCell.m
//  Sunburn
//
//  Created by Aseem on 04/09/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "InboxSettingsCell.h"

@implementation InboxSettingsCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _imageViewChatUser.layer.cornerRadius = 4;
    [_imageViewChatUser setClipsToBounds:YES];
    UIView * bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor =[UIColor colorWithRed:33.0f/255.0f green:43.0f/255.0f blue:56.0f/255.0f alpha:1];
    self.selectedBackgroundView = bgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
