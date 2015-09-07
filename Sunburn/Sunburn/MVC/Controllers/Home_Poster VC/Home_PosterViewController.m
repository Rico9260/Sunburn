//
//  Home_PosterViewController.m
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "Home_PosterViewController.h"

@implementation Home_PosterViewController


#pragma mark - View Hierarchy
-(void)viewDidLoad{
    
    [super viewDidLoad];
    _viewGridShown = NO;
    _viewGrid.hidden = YES;
}

#pragma mark - TABLE VIEW

#pragma mark - Table View Data Sources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return No of categories
    return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Home_Poster_ViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"Home_Poster_ViewCell"];
    
        return tableCell;
    
}

#pragma  mark - TableView Delegates



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.frame.size.height;
}

#pragma mark - COLLECTION VIEW

#pragma mark - CollectionView DataSources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == _collectionViewGridHorizontal) {
        //return no of categories
        return 5;
    }
    else if (collectionView == _collectionViewGridVertical){
        //return no of items in a category
        return 25;
    }
    else{
        //return no of items in a category
        return 10;
    }
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == _collectionViewGridHorizontal) {
        
        HomeGridBigCell *gridBigCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeGridBigCell" forIndexPath:indexPath];
                                        
    [self getcollectionView:gridBigCell.collectionViewVertical];
        return gridBigCell;
      
    }
    else if (collectionView == _collectionViewGridVertical){
        
       
        HomeGridSmallCell * gridSmallCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeGridSmallCell" forIndexPath:indexPath];
        return gridSmallCell;
    }
    else{
        
        Home_PosterCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Home_PosterCollectionCell" forIndexPath:indexPath];
        return collectionCell;
       
    }
    
    
}


#pragma mark - CollectionView Delegates

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    
    if (collectionView == _collectionViewGridHorizontal) {
        
        return self.view.frame.size;
    }
    else if (collectionView == _collectionViewGridVertical){
        
        return CGSizeMake(self.view.frame.size.width/2 - 1, self.view.frame.size.height /2 );
    }
    else{
        
        return self.view.frame.size;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    if (collectionView == _collectionViewGridHorizontal) {
        
        DetailsViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        [self presentViewController:VC animated:YES completion:nil];
        
    }
    else if (collectionView == _collectionViewGridVertical){
        
        DetailsViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        [self presentViewController:VC animated:YES completion:nil];
            }
    else{
        
        DetailsViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        [self presentViewController:VC animated:YES completion:nil];
    }
}

#pragma  mark - BUTTON ACTIONS

#pragma  mark - Button Actions

- (IBAction)btnAction_DrawerMenu:(id)sender {
    
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)btnAction_Alert:(id)sender {
    
}

- (IBAction)btnAction_Search:(id)sender {
    
    
}

- (IBAction)btnAction_Filter:(id)sender {
    
}

- (IBAction)btnAction_SwitchViews:(id)sender {
    
    
    if (NO == _viewGridShown) {
        
        [_btnSwitchViews setImage:[UIImage imageNamed:@"ic_view_poster.png"] forState:UIControlStateNormal];
        _viewGrid.hidden = NO;
        _viewGridShown = YES;
    }
    else{
        
        [_btnSwitchViews setImage:[UIImage imageNamed:@"ic_view_grid.png"] forState:UIControlStateNormal];
        _viewGrid.hidden = YES;
        _viewGridShown = NO;
    }
    
}

-(void)getcollectionView:(UICollectionView *) collectionView{
    
    _collectionViewGridVertical = collectionView;
}

@end
