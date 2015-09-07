//
//  InboxSettingsController.m
//  Sunburn
//
//  Created by Aseem on 04/09/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "InboxSettingsController.h"
#import "InboxSettingsCell.h"
#import <UIImageView+WebCache.h>
#import "Reachability.h"

@interface InboxSettingsController ()

@end

@implementation InboxSettingsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _loader = [[loaderView alloc] initWithFrame:self.view.frame];
    _tableViewChatUsers.tableFooterView = [[UIView alloc] initWithFrame:
                                           CGRectMake(0, 0, _tableViewChatUsers.frame.size.width, 10)];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self callingGetChatUsersApiWithLoader:YES];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegates and DataSources

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"User Blocked");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    
    return  [_arrChatUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    InboxSettingsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InboxSettingsCell"];
    
    [cell.imageViewChatUser sd_setImageWithURL:[[_arrChatUsers objectAtIndex:indexPath.row] valueForKey:@"profile_pic"]];
    [cell.labelUserName setText:[[_arrChatUsers objectAtIndex:indexPath.row] valueForKey:@"username"]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[_arrChatUsers objectAtIndex:indexPath.row] valueForKey:@"is_blocked"] integerValue] == 1) {
        
        UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Unblock" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            [self callingBlockUnblockUserApi:@"Unblock" andUserId:[[_arrChatUsers objectAtIndex:indexPath.row] valueForKey:@"user_id"]];
                                        }];
        button.backgroundColor = [UIColor greenColor]; //arbitrary color
        
        return @[button];
    }
    else{
        
        UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Block" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                          
            [self callingBlockUnblockUserApi:@"Block" andUserId:[[_arrChatUsers objectAtIndex:indexPath.row] valueForKey:@"user_id"]];
                                        }];
        button.backgroundColor = [UIColor redColor]; //arbitrary color
        return @[button];
    }
}
#pragma mark - API calls
-(void)callingGetChatUsersApiWithLoader:(BOOL)loader{
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet" :@"Please Check your internet connection"];
        return;
    }
    if(!_chatModal)
        _chatModal = [ChatModal new];
    
    if (loader)
    [self.view addSubview:_loader];
    [_loader startAnimating];
    
    [_chatModal callingGetChatUsers:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :^(NSDictionary *response_success) {
        
        if ([[response_success valueForKey:@"success"] integerValue] == 1) {
            
            self.arrChatUsers = [response_success valueForKey:@"all_users"];
            [_tableViewChatUsers reloadData];
            [_loader stopAnimating];
            [_loader removeFromSuperview];
        }
        else if ([[response_success valueForKey:@"success"] integerValue] == 2){
            
            [_loader stopAnimating];
            [_loader removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_Token];
            [self showAlertBox:@"Internet" :@"Please Check Your Internew Connection"];
        }
        else{
            
            [_loader stopAnimating];
            [_loader removeFromSuperview];
        }
        
    } :^(NSError *response_error) {
        
        NSLog(@"%@",response_error);
        [_loader stopAnimating];
        [_loader removeFromSuperview];
    }];
}

-(void)callingBlockUnblockUserApi:(NSString *)operation andUserId:(NSString *)userId{
    
    if ([operation isEqualToString:@"Block"]) {
        
        [_chatModal callingBlockUserApi:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :userId :^(NSDictionary *response_success) {
            
            if ([[response_success valueForKey:@"success"] integerValue] == 1) {
                
                [self showAlertBox:@"Success" :@"User Blocked Successfully"];
                [self callingGetChatUsersApiWithLoader:NO];
            }
            else if ([[response_success valueForKey:@"success"] integerValue] == 2){
                
                [_loader stopAnimating];
                [_loader removeFromSuperview];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_Token];
                [self showAlertBox:@"Internet" :@"Please Check Your Internew Connection"];
            }
            
        } :^(NSError *response_error) {
            
            
        }];
    }
    else{
        
        [_chatModal callingUnBlockUserApi:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :userId :^(NSDictionary *response_success) {
            
            if ([[response_success valueForKey:@"success"] integerValue] == 1) {
                
                [self showAlertBox:@"Success" :@"User Unblocked Successfully"];
                [self callingGetChatUsersApiWithLoader:NO];
            }
            else if ([[response_success valueForKey:@"success"] integerValue] == 2){
                
                [_loader stopAnimating];
                [_loader removeFromSuperview];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_Token];
                [self showAlertBox:@"Internet" :@"Please Check Your Internew Connection"];
            }
        } :^(NSError *response_error) {
            
            
        }];
    }
}
#pragma mark - Button Actions
- (IBAction)actionBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - Show Alert Box
-(void)showAlertBox:(NSString *)title :(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
