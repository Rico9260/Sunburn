//
//  SettingsViewController.m
//  Sunburn
//
//  Created by binit on 29/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "SettingsViewController.h"
#import "Reachability.h"

@implementation SettingsViewController


#pragma mark - View Hierarchy
-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self initializeCellAttributes];
}

-(void)initializeCellAttributes{
    
    
    _btnImages = [NSArray arrayWithObjects:@"settings_inbox.png",@"settings_email.png",@"settings_push.png",@"settings_del.png",@"settings_rate.png",@"settings_logout.png", nil];
    
    _btnTitles = [NSArray arrayWithObjects:@"Inbox Settings",@"Change email",@"Push notification settings",@"Delete account",@"Rate App",@"Logout", nil];
    
    _labelTitles_tc = [NSArray arrayWithObjects:@"Terms of service",@"Privacy policy", nil];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex{
    
    
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:29/255.0f green:35/255.0f blue:42/255.0f alpha:1.0f];
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex{
    
    
    if (sectionIndex == 0)
        return 0;
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath .section == 1 ){
        
        if (indexPath.row == 0) {
            
            TermsOfServiceController * VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_TOS];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    if (indexPath.section ==0) {
        
        InboxSettingsController * VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_InboxSettings];
        
        switch (indexPath.row) {
            case 0:
                
                [self.navigationController pushViewController:VC animated:YES];
                break;
            case 1:
                [self showAlertWithTextField];
                break;
            case 2:
                
                break;
            case 3:
                
                [self showAlertBox:@"Delete account" :@"Are you sure you want to delete your account" andSecondButtonTitle:@"ok" andtag:3];
                break;
            case 4:
                
                break;
            case 5:
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
            default:
                break;
        }
        
    }
}


#pragma mark - API Calls

-(void)callingDeleteAccountAPI{
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet Connection" :@"Please Check your Internet Connection"];
        return;
    }
    
    LoginModal * loginModal = [LoginModal new];
    [loginModal callingDeleteAccount:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :^(NSDictionary *response_success) {
        
        if ([[response_success valueForKey:@"success"] integerValue] == 1) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:UD_Token];
            [self showAlertBox:@"Success" :@"Account Deleted Successfully"];
        }
        else if([[response_success valueForKey:@"success"] integerValue] ==2){
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_Token];
            [self showAlertBox:@"Session Expired" :@"Please Login to continue."];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } :^(NSError *response_error) {
        
        NSLog(@"%@",response_error);
    }];
}
#pragma mark - TableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    
    
    if (sectionIndex == 0) {
        return 6;
    }
    else{
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section == 0) {
        
        SettingsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsTableCell"];
        
        [cell.label_Setting setText:[_btnTitles objectAtIndex:indexPath.row]];
        
        [cell.img_Setting setImage:[UIImage imageNamed:[_btnImages objectAtIndex:indexPath.row]]];
        
        return cell;
        
    }
    else{
        
        SettingsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsTableCell2"];
        [cell.label_tc setText:[_labelTitles_tc objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
    
}

#pragma mark - API Calls
-(void)callingLogoutApi{
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet Connection" :@"Please Check your Internet Connection"];
        return;
    }
    LoginModal * loginModal = [LoginModal new];
    
    [loginModal callingLogoutApi:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :^(NSDictionary *response_success) {
        
    } :^(NSError *response_error) {
        
        NSLog(@"%@",response_error);
    }];
}
-(void)callingChangeEmailApi:(NSString *)email{
    
    LoginModal * loginModal = [LoginModal new];
    
    [loginModal callingRegisterEduId:[[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token],@"token",email,@"email", nil] :^(NSDictionary *response_success) {
        
        if ([[response_success valueForKey:@"success"] integerValue] == 1) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[response_success valueForKey:@"user_details"] forKey:UD_UserInfo];
            [self showAlertBox:@"Success" :@"Email Changed Successfully"];
        }
        else
            [self showAlertBox:@"Invalid Email" :[response_success valueForKey:@"msg"]];
        
    } :^(NSError *response_error) {
        
        NSLog(@"%@",response_error);
    }];
}

#pragma mark - Button Actions

- (IBAction)actionBtn_Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Show Alert Box
-(void)showAlertBox:(NSString *)title :(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)showAlertBox:(NSString *)title :(NSString *)message andSecondButtonTitle:(NSString *)secondBtnTitle andtag:(NSUInteger)tag{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:secondBtnTitle,nil];
    alert.tag = tag;
    [alert show];
}
-(void)showAlertWithTextField{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change Email"
                                                    message:@"Please enter New Email-Id."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * textField = [alert textFieldAtIndex:0];
    textField.delegate = self;
    textField.placeholder = @"Enter New Edu Id";
    alert.tag = 1;
    [alert show];
}
#pragma mark - Alert View Delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView tag] == 3){
        
        if (buttonIndex == 1) {
            
            [self callingDeleteAccountAPI];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
    else if ([alertView tag] == 1){
        
        if (buttonIndex == 1) {
            
            if (![[[[alertView textFieldAtIndex:0] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
                [self callingChangeEmailApi:[[alertView textFieldAtIndex:0] text]];
            else
                [self showAlertBox:@"Field Empty" :@"Please Enter New Edu Id."];
            
        }
        else{
            
            [self.view endEditing:YES];
        }
    }
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
