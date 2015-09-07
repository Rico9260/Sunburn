//
//  DrawerViewController.h
//  Sunburn
//
//  Created by binit on 27/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"
#import "PanNavigationController.h"
#import "CategoryModal.h"

@interface DrawerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//temporary
@property PanNavigationController * navigationController;
@property NSMutableArray * arrCategories;
@property CategoryModal * categoryModal;
@property NSMutableDictionary * dictUserInfo;

#pragma mark - IBOutlets
@property (strong, nonatomic) IBOutlet UIImageView *imageView_UserImage;
@property (strong, nonatomic) IBOutlet UITableView *tableView_Categories;
@property (strong, nonatomic) IBOutlet UIButton *btnAction_ViewProfile;
@property NSUInteger selectedIndex;

#pragma mark - Button Actions
- (IBAction)actionBtn_PostLlisting:(id)sender;
- (IBAction)btnAction_ViewProfile:(id)sender;

@end
