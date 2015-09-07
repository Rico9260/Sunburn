//
//  EduIdViewController.h
//  Sunburn
//
//  Created by binit on 10/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModal.h"
#import "Import.h"
#import "SunburnUser.h"
#import "loaderView.h"

@interface EduIdViewController : UIViewController<UITextFieldDelegate>

@property LoginModal * loginModal;
@property (strong, nonatomic) IBOutlet UITextField *tf_EduId;
@property (strong, nonatomic) IBOutlet UIView *viewButton;
@property NSMutableDictionary *dictFBInfo;
@property NSData * dataFbImage;
@property SunburnUser * sunburnUserInfo;
@property loaderView * loader;
@property (weak, nonatomic) IBOutlet UITextField *tfLocation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableSearchResults;
@property NSMutableArray * arrSearchResults;
@property NSMutableArray * arrLocation;
-(void)getFacebookInfo:(NSMutableDictionary *) dict and:(NSData *)imageData;
#pragma mark - Button Actions
- (IBAction)actionBtn_Back:(id)sender;
- (IBAction)actionBtn_Submit:(id)sender;
- (IBAction)textFieldValueChanged:(id)sender;

@end
