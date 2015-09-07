//
//  HomeGridViewController.h
//  Sunburn
//
//  Created by binit on 03/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "Import.h"
#import "HomePosterViewController.h"
#import "SunburnUser.h"
#import "PostsModal.h"

@interface HomeGridViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

#pragma mark - IBOutlets
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewBigger;

#pragma mark - Properties
@property NSMutableArray * arrCategories;
@property NSArray * arrHomePosts;
@property HomePosterViewController * homePosterVC;
@property PostsModal * postsModal;
@property SunburnUser * sunburnUser;
@property NSIndexPath * previousIndexPath;
@end
