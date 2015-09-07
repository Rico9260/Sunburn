//
//  Home_PosterCollectionCell.m
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "Home_PosterCollectionCell.h"
#import "PostsModal.h"
#import "Macro.h"
#import <FBSDKCoreKit.h>

@implementation Home_PosterCollectionCell


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    
    if ([_strIsLiked integerValue] == 1) {
        
        [_btnLike setSelected:YES];
        [_btnLike.titleLabel setText:_strLikes];
    }
    CGFloat leftRightMin = -48.0f;
    CGFloat leftRightMax = 48.0f;
    
    CGFloat upDownMin = -48.0f;
    CGFloat upDownMax = 48.0f;
    
    
    UIInterpolatingMotionEffect * leftRight = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    leftRight.minimumRelativeValue = @(leftRightMin);
    leftRight.maximumRelativeValue = @(leftRightMax);
    
    
    UIInterpolatingMotionEffect * upDown = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    upDown.minimumRelativeValue = @(upDownMin);
    upDown.maximumRelativeValue = @(upDownMax);
    
    //Create a motion effect group
    UIMotionEffectGroup * meGroup = [[UIMotionEffectGroup alloc]init];
    meGroup.motionEffects = @[leftRight, upDown];
    
    //Add the motion effect group to our imageView
    [_imageView_Product addMotionEffect:meGroup];
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _viewListingInfo.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.0] CGColor], (id)[[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.5] CGColor], nil];
    [_viewListingInfo.layer insertSublayer:gradient atIndex:0];
    
    [_btnLike addTarget:self action:@selector(btnLikePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_btnShareFacebook addTarget:self action:@selector(btnSharePressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Button Actions

-(void)btnLikePressed:(id)sender{
    
    [_btnLike setSelected:YES];
    [self callingLikePostsApi:_postId];
}
-(void)btnSharePressed:(id)sender{
    
    [_btnShareFacebook setSelected:YES];
    [self callingSharePostsAPi:_postId];
}
-(void)callingLikePostsApi:(NSString *)postId{
    
    PostsModal * postsModal = [PostsModal new];
    [postsModal callingLikePostsApi:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :postId :^(NSDictionary *response_success) {
        if ([[response_success valueForKey:@"success"] integerValue] == 1) {
            
            _strLikes = [response_success valueForKey:@"like_count"];
            [_labelLikes setText:[response_success valueForKey:@"like_count"]];
        }
        else if([[response_success valueForKey:@"success"] integerValue] == 0){
            
            [_btnLike setSelected:YES];
        }
        else
            [_btnLike setSelected:YES];
        
    } :^(NSError *response_error) {
        
        NSLog(@"%@",response_error);
        
        [_btnLike setSelected:NO];
    }];
}

-(void)callingSharePostsAPi:(NSString *)postId{
    
    PostsModal * postsModal = [PostsModal new];
    UIImage *imgSource = _imageView_Product.image;
    NSString *strMessage = _labelProductName.text;
    NSMutableDictionary* photosParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         imgSource,@"source",
                                         strMessage,@"message",
                                         nil];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/photos" parameters:photosParams HTTPMethod:@"POST"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            
            [postsModal callingSharePostsApi:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :postId :^(NSDictionary *response_success) {
                
                if ([[response_success valueForKey:@"success"] integerValue] == 1) {
                    
                    [_labelShares setText:[response_success valueForKey:@"share_count"]];
                    [_btnLike setSelected:YES];
                }
                else if([[response_success valueForKey:@"success"] integerValue] == 0){
                    
                    [_btnLike setSelected:YES];
                }
                else
                    [_btnLike setSelected:NO];
                
            } :^(NSError *response_error) {
                
                [_btnShareFacebook setSelected:NO];
            }];
        }
        else{
            
            [_btnShareFacebook setSelected:NO];
        }
    }];
}
@end
