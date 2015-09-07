//
//  ListingsCollectionCell.h
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingsCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelDistance;
@property (strong, nonatomic) IBOutlet UIView *viewProductInfo;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProduct;

@end
