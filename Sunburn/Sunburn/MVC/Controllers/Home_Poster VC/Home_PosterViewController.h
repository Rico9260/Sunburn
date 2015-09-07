//
//  Home_PosterViewController.h
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"

@interface Home_PosterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


/**
 *  TableView Outlet For Home(Poster View)
 */
@property (strong, nonatomic) IBOutlet UITableView *tableView_Home_Poster;
//@property PanNavigationController *navigationController;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewGridHorizontal;
@property (strong, nonatomic) IBOutlet UIView *viewGrid;
@property (strong, nonatomic) IBOutlet UIButton *btnSwitchViews;
@property BOOL viewGridShown;
@property UICollectionView * collectionViewGridVertical;

#pragma mark - Button Actions
- (IBAction)btnAction_DrawerMenu:(id)sender;
- (IBAction)btnAction_Alert:(id)sender;
- (IBAction)btnAction_Search:(id)sender;
- (IBAction)btnAction_Filter:(id)sender;
- (IBAction)btnAction_SwitchViews:(id)sender;
@end
