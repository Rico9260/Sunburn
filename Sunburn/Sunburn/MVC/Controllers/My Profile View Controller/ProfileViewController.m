//
//  ProfileViewController.m
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "UserLocation.h"
#import "ProfileViewController.h"
#import "Reachability.h"

@implementation ProfileViewController

#pragma mark - View Hierarchy
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!_pickImage){
        [self initializeUI];
        [self callingProfilePostsApi];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}
#pragma mark - Setup Page View Controller
-(void)setupUI{
    
//    [self.navigationController.interactivePopGestureRecognizer setDelegate:self];
    [_imageViewUser setContentMode:UIViewContentModeScaleAspectFill];
    _btn_UserImage.layer.cornerRadius = 50;
    _btn_UserImage.clipsToBounds = YES;
    _btn_UserImage.layer.borderWidth = 2;
    _btn_UserImage.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.5] CGColor];
    _btnEditUserImage.layer.cornerRadius = 32;
    _btnEditUserImage.layer.borderWidth = 2;
    _btnEditUserImage.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.5] CGColor];
    [_btnEditUserImage setClipsToBounds:YES];
    [_viewEditProfile setHidden:YES];
    _pickImage = NO;
    [_tableViewLocation setHidden:YES];
    [_tableViewLocation.layer setCornerRadius:4];
    [_tableViewLocation setClipsToBounds:YES];
    
    UIButton *defaultClearButton = [UIButton appearanceWhenContainedIn:[UITextField class], nil];
    [defaultClearButton setBackgroundImage:[UIImage imageNamed:@"ic_close.png"] forState:UIControlStateNormal];
    
    
}
-(void)setupPageView{

    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    ActiveListingsViewController *first = [self.storyboard instantiateViewControllerWithIdentifier:VC_ActiveListings];
    [first getArrActiveLists:[_dictProfilePosts valueForKey:@"active_listing"]];
    NSArray *viewControllers = @[first];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [[_pageViewController view] setFrame:CGRectMake(0,0, self.view_pages.frame.size.width, _view_pages.frame.size.height)];
    
    [_btn_ExpiredListings.titleLabel setAlpha:0.33];
    [_btn_Likes.titleLabel setAlpha:0.33];
    
    [self addChildViewController:_pageViewController];
    [_view_pages addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

-(void)initializeUI{
    
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:UD_UserInfo];
    [_labelUserName setText:[dict valueForKey:@"username"]];
    [_labelUserLocation setText:[dict valueForKey:@"place"]];
    _username = _labelUserName.text;
    [_imageViewUser sd_setBackgroundImageWithURL:[dict valueForKey:@"profile_pic"] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        _imageData = UIImageJPEGRepresentation(image, 1);
        [_btnEditUserImage setBackgroundImage:image forState:UIControlStateNormal];
    }];
  
    [_tfLocation setPlaceholder:[dict valueForKey:@"place"]];
    [_tfName setPlaceholder:[dict valueForKey:@"username"]];
    if(_showLoader){
        _loader = [[loaderView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.view addSubview:_loader];
    }
}

#pragma mark - Api Calls

-(void)callingProfilePostsApi{
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet" :@"Please Check your internet connection"];
        return;
    }

    _postsModal = [PostsModal new];
    NSMutableArray * arrayLocation = [NSMutableArray new];
    
    if ([[UserLocation sharedSunburnUserLocation] arrLatLong] == nil) {
        
        arrayLocation = [[NSUserDefaults standardUserDefaults] valueForKey:UD_Location];
    }
    else{
        
        arrayLocation = [[UserLocation sharedSunburnUserLocation] arrLatLong];
    }
    [_loader startAnimating];
    [_postsModal callingMyProfilePostsApi:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :arrayLocation :^(NSDictionary *response_success) {
        
        if([[response_success valueForKey:@"success"] integerValue] == 1){
       
            _dictProfilePosts = [response_success copy];
        [self setupPageView];
        [_loader stopAnimating];
        [_loader removeFromSuperview];
        _showLoader = NO;
        }
        else if([[response_success valueForKey:@"success"] integerValue] ==2){
            
            [_loader stopAnimating];
            [_loader removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_Token];
            [self showAlertBox:@"Session Expired" :@"Please Login to continue."];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } :^(NSError *response_error) {
        
        NSLog(@"%@",[response_error debugDescription]);
        [_loader stopAnimating];
        [_loader removeFromSuperview];
    }];
}

-(void)callingEditProfileApi:(NSString *)name :(NSString *)location{
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet" :@"Please Check your internet connection"];
        return;
    }

   if (!_loginModal)
       _loginModal = [LoginModal new];
    
    [_loginModal callingEditProfile:[[NSDictionary alloc] initWithObjectsAndKeys:name,@"username",location,@"place",[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token],@"token", nil] :_imageData :^(NSDictionary *response_success) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[response_success valueForKey:@"user_details"] forKey:UD_UserInfo];
        [self initializeUI];
        [_loader stopAnimating];
        [_loader removeFromSuperview];
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            [_viewEditProfile setAlpha:0.0];
        } completion:^(BOOL finished) {
            
            [_viewEditProfile setHidden:YES];
        }];
        NSMutableArray * array = [NSMutableArray new];
        [array addObject:[NSString stringWithFormat:@"%f",[[_location valueForKey:@"lat"] doubleValue]]];
        [array addObject:[NSString stringWithFormat:@"%f",[[_location valueForKey:@"lng"] doubleValue]]];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:UD_Location];

    } :^(NSError *response_error) {
        
        [_loader stopAnimating];
        [_loader removeFromSuperview];
        NSLog(@"%@",[response_error localizedDescription]);
    }];
}

#pragma mark - Page View Controller Delegates
#pragma mark - Before View Controller

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:[ExpiredListingsViewController class]]){
        
        ActiveListingsViewController *recent = [self.storyboard instantiateViewControllerWithIdentifier:VC_ActiveListings];
        [recent getArrActiveLists:[_dictProfilePosts valueForKey:@"active_listing"]];
        return  recent;
    }
    else if ([viewController isKindOfClass:[LikesViewController class]]){
        
        ExpiredListingsViewController *mixed = [self.storyboard instantiateViewControllerWithIdentifier:VC_ExpiredListings];
        [mixed getArrExpiredLists:[_dictProfilePosts valueForKey:@"expired_listing"]];
        return  mixed;
    }
    else{
        
        return nil;
    }
}



#pragma mark - After view Controller
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:[ActiveListingsViewController class]]) {
        
        ExpiredListingsViewController *mixed = [self.storyboard instantiateViewControllerWithIdentifier:VC_ExpiredListings];
        [mixed getArrExpiredLists:[_dictProfilePosts valueForKey:@"expired_listing"]];
        return  mixed;
    }
    else if ([viewController isKindOfClass:[ExpiredListingsViewController class]]){
        
        LikesViewController *nearby = [self.storyboard instantiateViewControllerWithIdentifier:VC_Likes];
        [nearby getArrLikedLists:[_dictProfilePosts valueForKey:@"liked_listing"]];
        return  nearby;
    }
    else{
        
        return nil;
    }
}

#pragma mark - Did Finish animating

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    if (!completed) {
        
        return;
    }
    
    UIViewController *viewController = [pageViewController.viewControllers lastObject];
    
    if ([viewController isKindOfClass:[ActiveListingsViewController class]]) {
        
        _view_ButtonHighlight.frame = CGRectMake(0, 0, _btn_ActiveListings.frame.size.width, _view_ButtonHighlight.frame.size.height);
        
        if ([_btn_ActiveListings isEnabled]) {
            
            [_btn_ActiveListings.titleLabel setAlpha:1];
            [_btn_ExpiredListings.titleLabel setAlpha:0.33];
            [_btn_Likes.titleLabel setAlpha:0.33];
            
        }
        
    }
    else if ([viewController isKindOfClass:[ExpiredListingsViewController class]]) {
        
        _view_ButtonHighlight.frame = CGRectMake(_btn_ExpiredListings.frame.origin.x, 0, _btn_ExpiredListings.frame.size.width, _view_ButtonHighlight.frame.size.height);
        
        if ([_btn_ExpiredListings isEnabled]) {
            
            [_btn_ExpiredListings.titleLabel setAlpha:1];
            [_btn_ActiveListings.titleLabel setAlpha:0.33];
            [_btn_Likes.titleLabel setAlpha:0.33];
            
        }
        
    }
    else if ([viewController isKindOfClass:[LikesViewController class]]) {
        
        if ([_btn_Likes isEnabled]) {
            
            [_btn_Likes.titleLabel setAlpha:1];
            [_btn_ExpiredListings.titleLabel setAlpha:0.33];
            [_btn_ActiveListings.titleLabel setAlpha:0.33];
            
        }
        
        _view_ButtonHighlight.frame = CGRectMake(_btn_Likes.frame.origin.x, 0, _btn_Likes.frame.size.width, _view_ButtonHighlight.frame.size.height);
        
    }
    else {
        
        
    }
}

#pragma mark - ImagePicker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        _imageData = UIImageJPEGRepresentation([info valueForKey:UIImagePickerControllerEditedImage], 1.0);
    }
    else{
        
        _imageData = UIImageJPEGRepresentation([info valueForKey:UIImagePickerControllerOriginalImage], 0.5);
    }
    
    [_btnEditUserImage setBackgroundImage:[UIImage imageWithData:_imageData] forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Action Sheet Delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    if( buttonIndex == 0 ){
        
        
        _imagePicker.sourceType = UIImagePickerControllerCameraCaptureModePhoto;
        
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
    
    else if(buttonIndex ==1 ){
        
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:_imagePicker animated:YES completion:nil];
        
    }
    
}

#pragma mark - Table View Delegates and Datasources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_arrLocationResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableCell"];
    
        [cell.labelListingName setText:[NSString stringWithFormat:@"%@",[[_arrLocationResults objectAtIndex:indexPath.row] valueForKey:@"address"]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_tfLocation setText:[[_arrLocationResults objectAtIndex:indexPath.row] valueForKey:@"address"]];
    _location = [_arrLocationResults objectAtIndex:indexPath.row];
    [_tableViewLocation setHidden:YES];
}

#pragma mark - Button Action Handlers

- (IBAction)btnAction_showActiveListings:(id)sender {
    
    [self.view endEditing:YES];
    [_btn_ExpiredListings.titleLabel setAlpha:0.33];
    [_btn_Likes.titleLabel setAlpha:0.33];
    
    
    _btn_ActiveListings.exclusiveTouch = YES;
    
    [_view_ButtonHighlight setFrame:CGRectMake(0, 0, _btn_ActiveListings.frame.size.width, _view_ButtonHighlight.frame.size.height)];
    
    ActiveListingsViewController *active = [self.storyboard instantiateViewControllerWithIdentifier:VC_ActiveListings];
    [active getArrActiveLists:[_dictProfilePosts valueForKey:@"active_listing"]];
    [self.pageViewController setViewControllers:@[active] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)btnAction_showExpiredListings:(id)sender {
    
    [self.view endEditing:YES];
    [_btn_ActiveListings.titleLabel setAlpha:0.33];
    [_btn_Likes.titleLabel setAlpha:0.33];
    
    _btn_ExpiredListings.exclusiveTouch = YES;
    
    
    [_view_ButtonHighlight setFrame:CGRectMake(_btn_ExpiredListings.frame.origin.x, 0, _btn_ExpiredListings.frame.size.width, _view_ButtonHighlight.frame.size.height)];
    
    
    ExpiredListingsViewController *expired = [self.storyboard instantiateViewControllerWithIdentifier:VC_ExpiredListings];
    [expired getArrExpiredLists:[_dictProfilePosts valueForKey:@"expired_listing"]];
    [self.pageViewController setViewControllers:@[expired] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (IBAction)btnAction_showLikes:(id)sender {
    
    [self.view endEditing:YES];
    [_btn_ExpiredListings.titleLabel setAlpha:0.33];
    [_btn_ActiveListings.titleLabel setAlpha:0.33];
    
    _btn_Likes.exclusiveTouch = YES;
    
    [_view_ButtonHighlight setFrame:CGRectMake(_btn_Likes.frame.origin.x, 0, _btn_Likes.frame.size.width,_view_ButtonHighlight.frame.size.height)];
    
    
    LikesViewController *likes = [self.storyboard instantiateViewControllerWithIdentifier:VC_Likes];
    [likes getArrLikedLists:[_dictProfilePosts valueForKey:@"liked_listing"]];
    [self.pageViewController setViewControllers:@[likes] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (IBAction)btnAction_Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAction_Settings:(id)sender {
    
    SettingsViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_Settings];
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)btnAction_ShowInbox:(id)sender {
    
    InboxSettingsController * VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_InboxSettings];
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)btnAction_EditProfile:(id)sender {
    
    [_viewEditProfile setAlpha:0.0];
    [_viewEditProfile setHidden:NO];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        [_viewEditProfile setAlpha:1.0];
    } completion:nil];
}

- (IBAction)actionBtnChangePicture:(id)sender {
    
    [self.view endEditing:YES];
    _imagePicker = [UIImagePickerController new];
    [_imagePicker setDelegate:self];
    _pickImage = YES;
    [self showActionSheetForCamera];
}
- (IBAction)actionBtnCancel:(id)sender {
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        [_viewEditProfile setAlpha:0.0];
    } completion:^(BOOL finished) {
        
        [_viewEditProfile setHidden:YES];
    }];
    _pickImage = NO;
}

- (IBAction)actionBtnDone:(id)sender {
    
    [self.view endEditing:YES];
    _pickImage = NO;
    NSString * loc;
    if ([[_tfName.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        
        _username = _labelUserName.text;
        }
    else
        _username = _tfName.text;
    
     if ([[_tfLocation.text stringByTrimmingCharactersInSet:
               [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        
         loc = _labelUserLocation.text;
    }
    else{
        
        loc = [_location valueForKey:@"address"];
    }
    
    [self.view addSubview:_loader];
    [_loader startAnimating];
    [self callingEditProfileApi:_username :loc];
}

#pragma mark - Show ActionSheet
-(void)showActionSheetForCamera{
    
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:nil
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Gallery",@"Camera", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([_tfName isFirstResponder]) {
        
        [_tfLocation becomeFirstResponder];
    }
    else{
        
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - Show AlertBox
-(void)showAlertBoxWithMessage:(NSString *)message{
    
    JTAlertView *alert = [[JTAlertView alloc] initWithTitle:message andImage:[UIImage imageNamed:@"logo_navbar.png"]];
    [alert setSize:CGSizeMake(200, 150)];
    [alert setOverlayColor:[UIColor colorWithRed:28.0/255.0 green:38.0/255.0 blue:48.0/255.0 alpha:0.5]];
    [alert setParallaxEffect:YES];
    
    [alert addButtonWithTitle:@"OK" style:JTAlertViewStyleCancel action:^(JTAlertView *alertView) {
        
        [alertView hideWithCompletion:nil animated:YES];
    }];
    [alert showInSuperview:[[UIApplication sharedApplication] keyWindow] withCompletion:nil animated:YES];
}

- (IBAction)textFieldValueChanged:(id)sender {
    
    UITextField * textField = (UITextField *)sender;
    
    if(!_loginModal)
        _loginModal = [LoginModal new];
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet" :@"Please Check your internet connection"];
        return;
    }
    [_loginModal callingUserLocationApi:textField.text :^(NSDictionary *response_success) {
        
        NSLog(@"%@",response_success);
        _arrLocationResults = [response_success valueForKey:@"result"];
        [_tableViewLocation reloadData];
        [_tableViewLocation setHidden:NO];
        if ([_arrLocationResults count] < 5) {
            
            _constraintTableView.constant = [_arrLocationResults count] * 32;
        }
        else
            _constraintTableView.constant = 5 * 32;
        
    } :^(NSError *response_error) {
        
        NSLog(@"%@",[response_error localizedDescription]);
    }];
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
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
#pragma mark - Toches Began
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
#pragma mark - Gesture Recognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}
@end
