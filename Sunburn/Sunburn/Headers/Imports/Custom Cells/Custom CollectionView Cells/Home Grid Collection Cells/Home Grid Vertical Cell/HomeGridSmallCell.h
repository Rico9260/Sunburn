//
//  HomeGridSmallCell.h
//  Sunburn
//
//  Created by binit on 03/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"

@interface HomeGridSmallCell : UICollectionViewCell

#pragma mark - IBOutlets
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelDistance;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelTimer;
@property (strong, nonatomic) IBOutlet UIView *view_ProductDetails;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProduct;



@end
