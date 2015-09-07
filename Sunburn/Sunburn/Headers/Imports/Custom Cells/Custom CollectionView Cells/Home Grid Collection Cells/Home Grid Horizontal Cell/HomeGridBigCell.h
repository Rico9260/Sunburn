//
//  HomeGridBigCell.h
//  Sunburn
//
//  Created by binit on 03/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeGridBigCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewVertical;
@property (weak, nonatomic) IBOutlet UILabel *labelPlaceholder;

@end
