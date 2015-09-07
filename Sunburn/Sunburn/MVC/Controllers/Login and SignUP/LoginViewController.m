//
//  LoginViewController.m
//  Sunburn
//
//  Created by binit on 27/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "LoginViewController.h"
#import <RTSpinKitView.h>
#import "Reachability.h"
#import "UserLocation.h"

@implementation LoginViewController

#pragma mark - View Hierarchy

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self InitializeUI];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    if ([[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] != nil) {
        
        HomeContentController *VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_HomeContent];
        [self.navigationController pushViewController:VC animated:NO];
    }
}

#pragma mark - Segue Methods
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    return YES;
}

-(void)InitializeUI{
    
    _loginModal = [LoginModal new];
    _spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleArc color:[UIColor whiteColor]];
    UIButton *defaultClearButton = [UIButton appearanceWhenContainedIn:[UITextField class], nil];
    [defaultClearButton setBackgroundImage:[UIImage imageNamed:@"ic_close.png"] forState:UIControlStateNormal];
    UserLocation * location = [UserLocation sharedSunburnUserLocation];
    NSLog(@"%@ %@",[location longitude],[location latitude]);
}

#pragma mark - Button Actions
- (IBAction)actionBtnFacebookLogin:(id)sender {
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet Connection" :@"Please Check your Internet Connection"];
        return;
    }
    _spinner.center = _btnFacebook.center;
    [_spinner startAnimating];
    _login = [[FBSDKLoginManager alloc] init];
    [_login logOut];
    
    
        if (![FBSDKAccessToken currentAccessToken])
            [_login logInWithReadPermissions:@[@"user_hometown", @"email", @"user_about_me",@"user_location"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                [self.view addSubview:_spinner];
                
                if (error){
                    
                    [_btnFacebook setHidden:NO];
                    [_spinner stopAnimating];
                    NSLog(@"%@",[error localizedDescription]);
                    
                } else if (result.isCancelled){
                    
                    [_btnFacebook setHidden:NO];
                    [_spinner stopAnimating];
                    [self showAlertBox:@"Cancel" :@"You cancelled the facebook authorization"];
                } else{
                    
                    if ([result.grantedPermissions containsObject:@"email"]) {
                        
                        [_btnFacebook setHidden:YES];
                        [self getFaceBookData];
                    }
                }
            }];
   
}

#pragma mark - API Calls

-(void)getFaceBookData{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,email,location,picture.type(large),cover" forKey:@"fields"];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters HTTPMethod:@"GET"]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             
             if (!error) {
                 
                 NSMutableDictionary *dictfbInfo = [NSMutableDictionary new];
                 //                 NSLog(@"%@",result);
                 [dictfbInfo setObject:[[FBSDKAccessToken currentAccessToken] userID] forKey:@"fb_id"];
                 [dictfbInfo setObject:[result valueForKey:@"name"]  forKey:@"username"];
                 
                 NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[result valueForKeyPath:@"picture.data.url"]]];
                 
                 [self callingLoginFacebookApi:dictfbInfo :imageData];
             }
             else
                 NSLog(@"%@", [error localizedDescription]);
             
         }];
    }
    
}


-(void)callingLoginFacebookApi:(NSMutableDictionary *)dict :(NSData *)imagedata{
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet Connection" :@"Please Check your Internet Connection"];
        return;
    }
    [_loginModal callingLoginWithFaceBookApi:dict :imagedata :^(NSDictionary *response_success) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[[response_success valueForKey:@"user_details"] valueForKey:@"token"] forKey:UD_Token];
        [[NSUserDefaults standardUserDefaults] setObject:[response_success valueForKey:@"user_details"] forKey:UD_UserInfo];
        if (![[response_success valueForKeyPath:@"user_details.email"] isEqualToString:@""]) {
            
            [_spinner stopAnimating];
            [_spinner removeFromSuperview];
            
            HomeContentController *VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_HomeContent];
            
            [self.navigationController pushViewController:VC animated:YES];
            [_btnFacebook setHidden:NO];

        }
        else{
            
            [_spinner stopAnimating];
            [_spinner removeFromSuperview];
            EduIdViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_EduId];
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    } :^(NSError *response_error) {
        
        NSLog(@"%@",response_error);
        [_spinner stopAnimating];
        [_spinner removeFromSuperview];
        [_btnFacebook setHidden:NO];
        [self showAlertBox:@"No Internet" :@"Please Check your Internet Connection"];
    }];
}

#pragma mark - Show Alert Box
-(void)showAlertBox:(NSString *)title :(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
#pragma mark - Memory Warning
-(void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}
#pragma mark - Reachability

-(BOOL)internetWorking{
    
    Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
        
        return NO;
    }
    else{
    
        return YES;
    }
}
@end
