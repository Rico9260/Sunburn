//
//  EduIdViewController.m
//  Sunburn
//
//  Created by binit on 10/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "EduIdViewController.h"
#import "UserLocation.h"
#import "Reachability.h"

@interface EduIdViewController ()

@end

@implementation EduIdViewController

#pragma mark - View Hierarchy
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initializeUI];
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _loader = [[loaderView alloc] initWithFrame:self.view.frame];
}

-(void)initializeUI{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [_tableSearchResults setHidden:YES];
    [_tableSearchResults.layer setCornerRadius:4];
    [_tableSearchResults setClipsToBounds:YES];
    _loginModal = [LoginModal new];
    
}

#pragma mark - Calling Api

-(void)callingRegisterApi:(NSString *)eduId :(NSString *)place{
    
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] forKey:@"token"];
    [dict setObject:eduId forKey:@"email"];
    [dict setObject:place forKey:@"place"];
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet" :@"Please check your internet connection"];
        return;
    }
    [_loginModal callingRegisterEduId:dict :^(NSDictionary *response_success) {
        
        if (0 != [[response_success valueForKey:@"success"] integerValue]) {
            
            NSLog(@"%@",response_success);
            [[SunburnUser sharedSunburnUserInfo] setDictUserInfo:[response_success valueForKey:@"user_details"]];
            [[NSUserDefaults standardUserDefaults] setObject:[response_success valueForKey:@"user_details"] forKey:UD_UserInfo];
            [_loader stopAnimating];
            [_loader removeFromSuperview];
            HomeContentController *VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_HomeContent];
            
            [self.navigationController pushViewController:VC animated:YES];
        }
        else{
            
            [self showAlertBox:@"Invalid Email" :[response_success valueForKey:@"msg"]];
            [_loader stopAnimating];
            [_loader removeFromSuperview];
        }
        
    } :^(NSError *response_error) {
        
        NSLog(@"%@",[response_error localizedDescription]);
        [_loader stopAnimating];
        [_loader removeFromSuperview];
    }];
}



#pragma mark - Button Actions

- (IBAction)actionBtn_Back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionBtn_Submit:(id)sender {
    
    
    [self.view endEditing:YES];
    [self.view addSubview:_loader];
    [_loader startAnimating];
    if ([[_tf_EduId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        
        [self showAlertBox:@"Field Empty" :@"Please Enter Edu Id"];
        [_loader stopAnimating];
        [_loader removeFromSuperview];
    }
    else if ([[_tfLocation.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        
        [self showAlertBox:@"Field Empty" :@"Please Enter Location"];
        [_loader stopAnimating];
        [_loader removeFromSuperview];
    }
    else{
        NSMutableArray * array = [NSMutableArray new];
        [array addObject:[_arrLocation valueForKey:@"lat"]];
        [array addObject:[_arrLocation valueForKey:@"lng"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:UD_Location];
        [self callingRegisterApi:_tf_EduId.text :_tfLocation.text];
    }
}

- (IBAction)textFieldValueChanged:(id)sender {
    
    UITextField * textField = (UITextField *)sender;
    
    if(!_loginModal)
        _loginModal = [LoginModal new];
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet" :@"Please check your internet connection"];
        return;
    }
    
    [_loginModal callingUserLocationApi:textField.text :^(NSDictionary *response_success) {
        
        _arrSearchResults = [response_success valueForKey:@"result"];
        [_tableSearchResults reloadData];
        [_tableSearchResults setHidden:NO];
        if ([_arrSearchResults count] < 5) {
            
            _constraintTableHeight.constant = [_arrSearchResults count] * 32;
        }
        else
            _constraintTableHeight.constant = 5 * 32;
        
    } :^(NSError *response_error) {
        
        NSLog(@"%@",[response_error localizedDescription]);
    }];

}


#pragma mark - Touches Began

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark -  keyboard Notification handlers

- (void)keyboardWillHide:(NSNotification *)n{
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewButton.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

- (void)keyboardWillShow:(NSNotification *)n{
    
    
//    NSDictionary* userInfo = [n userInfo];
    
//    CGPoint keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin;
    [UIView animateWithDuration:0.3 animations:^{
        _viewButton.transform = CGAffineTransformMakeTranslation(0,-20);
    }];
    
}

#pragma mark - Text Field Delegates


- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    
    if ([textField isFirstResponder]) {
        
        [textField resignFirstResponder];
    }
    else{
        
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - Table View Delegates and Datasources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_arrSearchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableCell"];
    
    [cell.labelListingName setText:[NSString stringWithFormat:@"%@",[[_arrSearchResults objectAtIndex:indexPath.row] valueForKey:@"place"]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    [_tfLocation setText:[[_arrSearchResults objectAtIndex:indexPath.row] valueForKey:@"place"]];
    _arrLocation = [_arrSearchResults objectAtIndex:indexPath.row];
    
    [_tableSearchResults setHidden:YES];
}


-(void)showAlertBox:(NSString *)title :(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)getFacebookInfo:(NSMutableDictionary *) dict and:(NSData *)imageData{
    
    _dictFBInfo = [NSMutableDictionary new];
    _dataFbImage = [NSData new];
    _dataFbImage = imageData;
    _dictFBInfo = dict;
}

- (void)didReceiveMemoryWarning {
    
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
