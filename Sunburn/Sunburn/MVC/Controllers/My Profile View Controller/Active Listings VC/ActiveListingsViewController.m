//
//  ActiveListingsViewController.m
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "ActiveListingsViewController.h"
#import <UIImageView+WebCache.h>

@implementation ActiveListingsViewController

#pragma mark - View Hierarchy
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if ([_arrActiveListings count] != 0) {
        
        [_labelPlaceHolder setHidden:YES];
    }
    else
        [_labelPlaceHolder setHidden:NO];
    
    [_collectionViewActive reloadData];
}

#pragma mark - COLLECTION VIEW

#pragma mark - CollectionView DataSources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_arrActiveListings count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ListingsCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActiveListingsCollectionCell" forIndexPath:indexPath];
    collectionCell.contentView.frame = [collectionCell bounds];
    
    PostsModal * postsModal = [_arrActiveListings objectAtIndex:indexPath.row];
    
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

#pragma mark - Button Actions
- (void)actionBtnMore:(id)sender{
    
    DetailsViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_Details];
    
    [VC getDetailPostInfo:[_arrActiveListings objectAtIndex:[sender tag]]];
    [self presentViewController:VC animated:YES completion:nil];
}
-(void)getArrActiveLists:(NSArray *)arrActiveListings{
    
    _arrActiveListings = [PostsModal parseCategoryFeedToArray:[arrActiveListings mutableCopy]];
    [_collectionViewActive reloadData];
}
@end
