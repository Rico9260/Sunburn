//
//  SettingsViewController.h
//  Sunburn
//
//  Created by binit on 29/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>


@property NSArray *btnImages;
@property NSArray *btnTitles;
@property NSArray *labelTitles_tc;

#pragma mark - Button Actions

- (IBAction)actionBtn_Back:(id)sender;

@end
