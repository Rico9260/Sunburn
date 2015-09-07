//
//  SidePanelHeaderView.m
//  Foodi
//
//  Created by Rajat Sharma on 13/05/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import "SidePanelHeaderView.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "UIImage+BlurredFrame.h"

@implementation SidePanelHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SidePanelHeaderView" owner:self options:nil] lastObject];
        [self setFrame:frame];
    }
        
    return self;
}


-(void)setupHeaderView :(NSMutableDictionary *)dictUserInfo{
   
    _dictUserInfo = dictUserInfo;
    
    [_imageViewUser sd_setImageWithURL:[_dictUserInfo valueForKey:@"profile_pic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self addBlurToImageView:image];
    }];
  
    [_btnUserProfile sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_dictUserInfo valueForKey:@"profile_pic"] stringByAppendingString:@"/64/64"]] forState:UIControlStateNormal];
    self.btnUserProfile.layer.cornerRadius = self.btnUserProfile.frame.size.width/2;
    self.btnUserProfile.clipsToBounds = YES;
    self.btnUserProfile.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.5] CGColor];
    self.btnUserProfile.layer.borderWidth = 2.f;
    
}

-(void)addBlurToImageView:(UIImage *)image{
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                       
                       UIImage *img =  [image applyBlurWithRadius:10 tintColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]  saturationDeltaFactor:1 maskImage:nil];
                       dispatch_sync(dispatch_get_main_queue(), ^{
                           [_imageViewUser setImage:img];
                       });
                   });
    
}

- (IBAction)actionBtnPostListing:(id)sender {
    
    [self.delegate btnPostListing];
}

- (IBAction)actionBtnUserProfile:(id)sender {
 
    [self.delegate btnMyProfile];
}
@end
