//
//  LikesViewController.h
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"
@interface LikesViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewLikes;

@property (weak, nonatomic) IBOutlet UILabel *labelLikedPosts;
@property NSArray * arrLikedListings;
-(void)getArrLikedLists:(NSArray *)arrLikedListings;
@end
