//
//  ExpiredListingsViewController.h
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"
@interface ExpiredListingsViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewExpired;
@property (weak, nonatomic) IBOutlet UILabel *labelExpiredPosts;

@property NSArray * arrExpiredListings;
-(void)getArrExpiredLists:(NSArray *)arrExpiredListings;
@end
