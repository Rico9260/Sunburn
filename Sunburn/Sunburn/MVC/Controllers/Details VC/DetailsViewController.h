//
//  DetailsViewController.h
//  Sunburn
//
//  Created by binit on 29/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"
#import "PostsModal.h"
#import "UserLocation.h"

@interface DetailsViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property PostsModal * postsModal;

-(void)getDetailPostInfo:(PostsModal *)postsModal;

#pragma mark - IBOutlets
@property (strong, nonatomic) IBOutlet UIButton *btn_Message;
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelCollegeName;
@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UILabel *labelDistance;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPostingUser;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelLikes;
@property (strong, nonatomic) IBOutlet UILabel *labelShares;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *viewBar;

@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnShareFacebook;

#pragma mark - Button Actions
- (IBAction)actionBtn_Message:(id)sender;
- (IBAction)actionBtn_Like:(id)sender;
- (IBAction)actionBtn_ShareFacebook:(id)sender;
- (IBAction)actionBtn_Back:(id)sender;
@end
