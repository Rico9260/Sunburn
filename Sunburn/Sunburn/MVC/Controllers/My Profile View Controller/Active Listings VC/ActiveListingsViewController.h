//
//  ActiveListingsViewController.h
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"

@interface ActiveListingsViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewActive;
@property NSArray * arrActiveListings;
@property (weak, nonatomic) IBOutlet UILabel *labelPlaceHolder;
-(void)getArrActiveLists:(NSArray *)arrActiveListings;
@end
