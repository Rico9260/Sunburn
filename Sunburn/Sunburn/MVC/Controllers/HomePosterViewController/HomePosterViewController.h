//
//  HomePosterViewController.h
//  Sunburn
//
//  Created by binit on 05/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"
#import "PostsModal.h"
#import "SunburnUser.h"
#import "loaderView.h"

static dispatch_once_t onceToken;

@interface HomePosterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property NSMutableArray * arrCategories;
@property NSArray * arrFilterPosts;
@property NSArray * arrCategoryPosts;
@property (strong, nonatomic) IBOutlet UITableView *tableViewCategories;
@property NSString * stringCategoryName;
@property NSString * stringCategoryNo;
@property NSString * stringNoOfContents;
@property NSMutableDictionary * dictNotification;
@property PostsModal * postsModal;
@property SunburnUser * sunburnUser;
@property NSMutableDictionary * dictPostsWRTCategory;
@property UICollectionView * collectionViewHorizontal;
@property NSIndexPath * previousIndexPath;
@property loaderView * loader;
@property BOOL filter;
@property BOOL firstTimeAppRun;
@end



