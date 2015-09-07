//
//  SidePanelView.h
//  Foodi
//
//  Created by Rajat Sharma on 13/05/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidePanelHeaderView.h"

@protocol SidePanelDelegate

@optional
-(void)setSidePanelDelegates;
-(void)sidePanelIndexClicked : (NSIndexPath *)indexPath;
-(void)hideSidePanelAndAnimation : (BOOL)animate;
-(void)btnPostListingClicked;
-(void)btnMyProfileClicked;

@end

@interface SidePanelView : UIView <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, UITextFieldDelegate,SidePanelHeaderDelegate>

#pragma mark - Properties
@property (nonatomic,assign) id <SidePanelDelegate> delegate;
@property (nonatomic,strong) SidePanelHeaderView *headerObj;

@property (nonatomic) BOOL showUsers;
@property (nonatomic) BOOL isApiHit;
@property (nonatomic,strong) NSMutableDictionary *profileDict;
@property (nonatomic,strong) NSMutableArray *arrCategory;
@property NSUInteger selectedIndex;

#pragma mark - Outlets
@property (weak, nonatomic) IBOutlet UITableView *sidePanelTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@end
