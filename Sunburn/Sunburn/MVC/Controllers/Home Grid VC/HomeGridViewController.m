//
//  HomeGridViewController.m
//  Sunburn
//
//  Created by binit on 03/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "HomeGridViewController.h"

@implementation HomeGridViewController



#pragma mark - View Hierarchy

-(void)viewDidLoad{
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self initializeUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveIndex:) name:N_CategorySwitch object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    _previousIndexPath = [NSIndexPath new];
    _previousIndexPath = [[_collectionViewBigger indexPathsForVisibleItems] lastObject];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initializeUI{
    
    _arrCategories = [[NSUserDefaults standardUserDefaults] valueForKey:UD_Categories];
    _sunburnUser = [SunburnUser sharedSunburnUserInfo];
    _arrHomePosts = [NSMutableArray new];
    
    [_collectionViewBigger reloadData];
    
    NSMutableDictionary * dictNotification = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"All Categories",@"Name",@"",@"No",[NSString stringWithFormat:@"%lu",(unsigned long)[[_sunburnUser.dictPostsWRTCategory valueForKey:@"all_posts"] count]],@"Contents", nil];
    [self postLabelNotification:dictNotification];
    [_collectionViewBigger scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - Notification Selector

-(void)recieveIndex:(NSNotification *)notification{
    
    NSIndexPath * indexpath = (NSIndexPath *) [notification.userInfo valueForKey:@"indexPath"];
    NSString * stringCategoryName;
    NSMutableDictionary * dictNotification = [NSMutableDictionary new];
    [dictNotification setObject:@"" forKey:@"No"];

    if (indexpath.row == 0) {
        
        stringCategoryName = @"All Categories";
        [dictNotification setObject:stringCategoryName forKey:@"Name"];
        NSString * stringContents = [NSString stringWithFormat:@"%ld",(unsigned long)[[_sunburnUser.dictPostsWRTCategory valueForKey:@"all_posts"] count]];
        [dictNotification setObject:stringContents forKey:@"Contents"];
    }
    else{
        
        stringCategoryName = [[_arrCategories objectAtIndex:indexpath.row - 1] valueForKey:@"category_name"];
        [dictNotification setObject:stringCategoryName forKey:@"Name"];
        NSString * stringContents = [NSString stringWithFormat:@"%ld",(unsigned long)[[_sunburnUser.dictPostsWRTCategory valueForKey:stringCategoryName] count]];
        [dictNotification setObject:stringContents forKey:@"Contents"];
    }
    
    [self postLabelNotification:dictNotification];
    [_collectionViewBigger scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}



#pragma mark - CollectionView Datasources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([collectionView isEqual:_collectionViewBigger]) {

        return [_arrCategories count] + 1;
    }
    else
        return [_arrHomePosts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectionView isEqual:_collectionViewBigger]) {
        
        
        HomeGridBigCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeGridBigCell" forIndexPath:indexPath];
        if (indexPath.row != 0) {
            NSMutableDictionary * dict = [_sunburnUser.dictPostsWRTCategory mutableCopy];
            _arrHomePosts = [PostsModal parseCategoryFeedToArray:[dict valueForKey:[[_arrCategories objectAtIndex:indexPath.row - 1] valueForKey:@"category_name"]]];
            
            if ([_arrHomePosts count] == 0) {
                
                [cell.labelPlaceholder setHidden:NO];
            }
            else{
                
                [cell.labelPlaceholder setHidden:YES];
            }
            [cell.collectionViewVertical reloadData];
        }
        else{
            
              _arrHomePosts = [PostsModal parseCategoryFeedToArray:[_sunburnUser.dictPostsWRTCategory valueForKey:@"all_posts"]];
            if ([_arrHomePosts count] == 0) {
                
                [cell.labelPlaceholder setHidden:NO];
            }
            else{
                
                [cell.labelPlaceholder setHidden:YES];
            }
            [cell.collectionViewVertical reloadData];
        }
        return cell;
    }
    else{
        
        HomeGridSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeGridSmallCell" forIndexPath:indexPath];
        PostsModal * postsModal = [_arrHomePosts objectAtIndex:indexPath.row];
        [cell.labelProductName setText:postsModal.strTitle];
        
        [cell.labelDistance setText:[NSString stringWithFormat:@"%@ miles away",postsModal.strDistance]];
        
        [cell.labelPrice setText:[NSString stringWithFormat:@"%@%@",postsModal.strCurrnecy,postsModal.strPrice]];
        
        [cell.labelTimer setText:postsModal.strTimeSince];
        
        
        [cell.imageViewProduct sd_setImageWithURL:[postsModal.images lastObject]];
   
        [cell.btnMore addTarget:self action:@selector(actionBtnMore:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnMore setTag:indexPath.row];
        
        return cell;
    }
    
}

#pragma mark - Collection view Delegates

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectionView isEqual:_collectionViewBigger]) {
        
        return self.view.frame.size;
    }
    else{
        
        return CGSizeMake(self.view.frame.size.width/2 - 1, self.view.frame.size.height / 2.1);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if ([scrollView isEqual:_collectionViewBigger]) {
        
        UICollectionView * collectionview = (UICollectionView *)scrollView;
        CGRect visibleRect = (CGRect){.origin = collectionview.contentOffset, .size = collectionview.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        NSIndexPath *visibleIndexPath = [collectionview indexPathForItemAtPoint:visiblePoint];
        
        NSString * stringCategoryName;
        NSMutableDictionary * dictNotification = [NSMutableDictionary new];
        [dictNotification setObject:@"" forKey:@"No"];
      
        if (visibleIndexPath.row == 0) {
            
            stringCategoryName = @"All Categories";
            [dictNotification setObject:stringCategoryName forKey:@"Name"];
            
            NSString * stringContents = [NSString stringWithFormat:@"%ld",(unsigned long)[[_sunburnUser.dictPostsWRTCategory valueForKey:@"all_posts"] count]];
            [dictNotification setObject:stringContents forKey:@"Contents"];
        }
        else{
            
            stringCategoryName = [[_arrCategories objectAtIndex:visibleIndexPath.row - 1] valueForKey:@"category_name"];
            [dictNotification setObject:stringCategoryName forKey:@"Name"];
            
            NSString * stringContents = [NSString stringWithFormat:@"%ld",(unsigned long)[[_sunburnUser.dictPostsWRTCategory valueForKey:stringCategoryName] count]];
            [dictNotification setObject:stringContents forKey:@"Contents"];
        }
        
        [self postLabelNotification:dictNotification];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if ([scrollView isEqual:_collectionViewBigger]) {
        
        UICollectionView * collectionview = (UICollectionView *)scrollView;
        CGRect visibleRect = (CGRect){.origin = collectionview.contentOffset, .size = collectionview.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        NSIndexPath *visibleIndexPath = [collectionview indexPathForItemAtPoint:visiblePoint];
        
        NSString * stringCategoryName;
        NSMutableDictionary * dictNotification = [NSMutableDictionary new];
        [dictNotification setObject:@"" forKey:@"No"];
        
        if (visibleIndexPath.row == 0) {
            
            stringCategoryName = @"All Categories";
            [dictNotification setObject:stringCategoryName forKey:@"Name"];
            
            NSString * stringContents = [NSString stringWithFormat:@"%ld",(unsigned long)[[_sunburnUser.dictPostsWRTCategory valueForKey:@"all_posts"] count]];
            [dictNotification setObject:stringContents forKey:@"Contents"];
        }
        else{
            
            stringCategoryName = [[_arrCategories objectAtIndex:visibleIndexPath.row - 1] valueForKey:@"category_name"];
            [dictNotification setObject:stringCategoryName forKey:@"Name"];
            
            NSString * stringContents = [NSString stringWithFormat:@"%ld",(unsigned long)[[_sunburnUser.dictPostsWRTCategory valueForKey:stringCategoryName] count]];
            [dictNotification setObject:stringContents forKey:@"Contents"];
        }
        
        [self postLabelNotification:dictNotification];
    }

}
- (void)actionBtnMore:(id)sender{
    
    DetailsViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_Details];
    
    if ([_arrHomePosts count] != 0) {
        
        [VC getDetailPostInfo:[_arrHomePosts objectAtIndex:[sender tag]]];
    }
    [self presentViewController:VC animated:YES completion:nil];
}

-(void)postLabelNotification:(NSMutableDictionary *)dictLabel{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:N_LabelContent object:nil userInfo:dictLabel];
}

@end

