//
//  Home_PosterCollectionCell.h
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Home_PosterCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Product;
@property (strong, nonatomic) IBOutlet UIView *viewListingInfo;
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelUniversityName;
@property (strong, nonatomic) IBOutlet UILabel *labelPostingUser;
@property (strong, nonatomic) IBOutlet UILabel *labelDistance;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UILabel *labelLikes;
@property (strong, nonatomic) IBOutlet UILabel *labelShares;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnShareFacebook;
@property NSString * postId;
@property NSString * strIsLiked;
@property NSString * strLikes;
@end
