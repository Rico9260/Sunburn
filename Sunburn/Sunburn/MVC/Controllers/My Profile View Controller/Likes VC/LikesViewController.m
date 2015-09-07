//
//  LikesViewController.m
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "LikesViewController.h"
#import <UIImageView+WebCache.h>

@implementation LikesViewController

#pragma mark - View Hierarchy
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([_arrLikedListings count] != 0) {
        
        [_labelLikedPosts setHidden:YES];
    }
    else
        [_labelLikedPosts setHidden:NO];
}

#pragma mark - COLLECTION VIEW

#pragma mark - CollectionView DataSources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_arrLikedListings count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ListingsCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikesCollectionCell" forIndexPath:indexPath];
    collectionCell.contentView.frame = [collectionCell bounds];
    PostsModal * postsModal = [_arrLikedListings objectAtIndex:indexPath.row];
    
    [collectionCell.labelDistance setText:[NSString stringWithFormat:@"%@ mi away",postsModal.strDistance]];
    [collectionCell.labelPrice setText:[NSString stringWithFormat:@"%@%@",postsModal.strCurrnecy,postsModal.strPrice]];
    [collectionCell.labelProductName setText:postsModal.strTitle];
    [collectionCell.labelTime setText:postsModal.strTimeSince];
    [collectionCell.btnMore addTarget:self action:@selector(actionBtnMore:) forControlEvents:UIControlEventTouchUpInside];
    [collectionCell.btnMore setTag:indexPath.row];
    [collectionCell.imageViewProduct sd_setImageWithURL:[NSURL URLWithString:[postsModal.images lastObject]]];
    return collectionCell;
}


#pragma mark - CollectionView Delegates

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeMake(self.view.frame.size.width/2 - 1  ,self.view.frame.size.width * 0.88);
}

- (void)actionBtnMore:(id)sender{
    
    DetailsViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_Details];
    
    [VC getDetailPostInfo:[_arrLikedListings objectAtIndex:[sender tag]]];
    [self presentViewController:VC animated:YES completion:nil];
}

-(void)getArrLikedLists:(NSArray *)arrLikedListings{
    
    _arrLikedListings = [PostsModal parseCategoryFeedToArray:[arrLikedListings mutableCopy]];
    [_collectionViewLikes reloadData];
}
@end
