//
//  NotificationViewController.h
//  Sunburn
//
//  Created by binit on 03/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"

@interface NotificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

#pragma mark - IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *tableView_Notifications;

#pragma mark - Button Actions
- (IBAction)actionBtn_Back:(id)sender;
- (IBAction)actionBtn_ClearAll:(id)sender;

@end
