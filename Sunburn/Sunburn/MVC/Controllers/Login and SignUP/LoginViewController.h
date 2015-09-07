//
//  LoginViewController.h
//  Sunburn
//
//  Created by binit on 27/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"
#import <FBSDKCoreKit.h>
#import <FBSDKLoginKit.h>
#import "LoginModal.h"
#import <RTSpinKitView.h>
#import <CoreLocation/CoreLocation.h>
@interface LoginViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property RTSpinKitView * spinner;
@property LoginModal * loginModal;
@property FBSDKLoginManager *login;

#pragma mark - Button Actions
- (IBAction)actionBtnFacebookLogin:(id)sender;

@end
