//
//  Home_Poster_ViewCell.h
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Home_Poster_ViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPoster;
@property (weak, nonatomic) IBOutlet UILabel *labelPlaceholder;
@end
