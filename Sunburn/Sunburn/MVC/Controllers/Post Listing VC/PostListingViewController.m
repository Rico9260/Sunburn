//
//  PostListingViewController.m
//  Sunburn
//
//  Created by binit on 29/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "PostListingViewController.h"
#import "Reachability.h"

@implementation PostListingViewController{
    
    bool pickStartDate;
    id currentField;
}


#pragma mark - View Hierarchy

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self initializeUI];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_viewLoading setHidden:YES];
    [self registerKeyboardNotifications];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self unregisterKeyboardNotifications];
}

-(void)initializeUI {
    
    _spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWanderingCubes color:[UIColor whiteColor]];
    _spinner.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), CGRectGetMidY([[UIScreen mainScreen] bounds]));
    [_viewLoading addSubview:_spinner];
    [self.frostedViewController setPanGestureEnabled:YES];
    pickStartDate = YES;
    _arrListingImages = [NSMutableArray new];
    _categories = [[NSUserDefaults standardUserDefaults]valueForKey:UD_Categories];
    _dictUserInfo = [[NSUserDefaults standardUserDefaults] valueForKey:UD_UserInfo];
    _arrCurrencies = [[NSMutableArray alloc] initWithObjects:@"₹",@"£",@"$", nil];
    [self addTextViewPlaceholder:_textView_Description withPlaceholder:@"Description"];
    [_labelCollegeName setText:[_dictUserInfo valueForKey:@"university_name"]];
    [_labelEmail setText:[NSString stringWithFormat:@"associated with %@",[_dictUserInfo valueForKey:@"email"]]];
}

#pragma mark - COLLECTION VIEW

#pragma mark - CollectionView DataSources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_arrListingImages count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PostListingCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostListingCollectionCell" forIndexPath:indexPath];
    [collectionCell.imageView_PostListing.layer setCornerRadius:5];
    collectionCell.imageView_PostListing.clipsToBounds = YES;
    [collectionCell.imageView_PostListing setImage:[UIImage imageWithData:[_arrListingImages objectAtIndex:indexPath.item]]];
    return collectionCell;
}


#pragma mark - TextView Delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    
    if([textView.text length] > 0)
        [[textView viewWithTag:999] setAlpha:0];
    else
        [[textView viewWithTag:999] setAlpha:1];
    
}

#pragma mark - Text Field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([_tf_ListingName isFirstResponder]){
    
        [_textView_Description becomeFirstResponder];
        return NO;
    }
    if ([_tf_Price isFirstResponder]) {
        
        [_tf_Price resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    currentField = textField;
}


#pragma mark - THDate Picker Delegate

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    
    [self dismissSemiModalView];
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate {
    
    NSDateFormatter * formatterForLabel = [[NSDateFormatter alloc] init];
    
    [formatterForLabel setDateFormat:@"dd MMM YYYY"];
    
    _selectedDate = [formatterForLabel stringFromDate:selectedDate];
    //    NSLog(@"%@",[formatterForApi stringFromDate:selectedDate]);
    
    if (pickStartDate) {
        
        [_labelStartDate setText:_selectedDate];
        _startDate = selectedDate;
    }
    else {
        
        [_labelEndDate setText:_selectedDate];
        _endDate = selectedDate;
        
    }
}

#pragma mark - Action Sheet Delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    else if (actionSheet.tag == 1) {
        
        [_labelCategoryPick setText:[[_categories objectAtIndex:buttonIndex - 1] valueForKey:@"category_name"]];
        _categoryId = buttonIndex;
    }
    else{
        
        [_labelCurrency setText:[_arrCurrencies objectAtIndex:buttonIndex - 1]];
    }
}
#pragma mark - ImagePicker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSData * imageData;
        imageData = UIImageJPEGRepresentation([info valueForKey:UIImagePickerControllerEditedImage], 1.0);
    
    [_arrListingImages addObject:imageData];
    [_collectionViewListingImages reloadData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Touches Began
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([_tf_ListingName isFirstResponder]) {
        
        [_tf_ListingName resignFirstResponder];
    }
    
    [self.scrollViewListingContent endEditing:YES];
    [self.view endEditing:YES];
    [_view_postContent endEditing:YES];
}


#pragma mark - Button Actions

- (IBAction)btnAction_AddPictures:(id)sender {
    
    [self.view endEditing:YES];
    _imagePicker =[[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.delegate = self;
    [_imagePicker setAllowsEditing:YES];
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (IBAction)btnAction_ChooseCategory:(id)sender {
    
    [self showActionSheetWithTitle:@"Select Category" buttonTitleArray:_categories andTag:1];
    [self.view endEditing:YES];
}

- (IBAction)btnAction_ChooseCurrency:(id)sender {
    
    [self showActionSheetWithTitle:@"Select Currency" buttonTitleArray:_arrCurrencies andTag:2];
    [self.view endEditing:YES];
}

- (IBAction)btnAction_PickStartDate:(id)sender {
    
    pickStartDate = YES;
    
    if(!self.datePicker)
        self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = [NSDate date];
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setClearAsToday:YES];
    [self.datePicker setAutoCloseOnSelectDate:YES];
    [self.datePicker setAllowSelectionOfSelectedDate:YES];
    [self.datePicker setDisableHistorySelection:YES];
    [self.datePicker setDisableFutureSelection:NO];
    [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:28/255.0 green:38/255.0 blue:48/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    
    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        int tmp = (arc4random() % 30)+1;
        if(tmp % 5 == 0)
            return YES;
        return NO;
    }];
    //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(0.2),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.0),
                                                                  }];
    
}

- (IBAction)btnAction_PickEndDate:(id)sender {
    
    pickStartDate = NO;
    if(!self.datePicker)
        self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = [NSDate date];
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setClearAsToday:YES];
    [self.datePicker setAutoCloseOnSelectDate:YES];
    [self.datePicker setAllowSelectionOfSelectedDate:YES];
    [self.datePicker setDisableHistorySelection:YES];
    [self.datePicker setDisableFutureSelection:NO];
    [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:28/255.0 green:38/255.0 blue:48/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    
    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        int tmp = (arc4random() % 30)+1;
        if(tmp % 5 == 0)
            return YES;
        return NO;
    }];
    //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(0.2),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.0),
                                                                  }];
    
    
}

- (IBAction)btnAction_ClearAll:(id)sender {
    
    [_textView_Description setText:@""];
    if ([_textView_Description.text isEqualToString:@""]) {
        
        [[_textView_Description viewWithTag:999] setAlpha:1];
    }
    [_tf_ListingName setText:@""];
    [_tf_Price setText:@""];
    [_labelCategoryPick setText:@"Choose a Category"];
    [_labelStartDate setText:@"Start Date"];
    [_labelEndDate setText:@"End Date"];
    [_labelCurrency setText:@"$"];
    [_arrListingImages removeAllObjects];
    [_collectionViewListingImages reloadData];
}

- (IBAction)btnAction_Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAction_ReviewListing:(id)sender {
    
    _postListingModal = [PostListingModal new];
    if ([[_tf_ListingName.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        
        [self showAlertBoxWithTitle:@"Field Empty" Message:@"Please Enter Post Title"];
    }
    else if ([[_textView_Description.text stringByTrimmingCharactersInSet:
                                         [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        [self showAlertBoxWithTitle:@"Description" Message:@"Please Enter Listing Description"];
    else if ([_labelCategoryPick.text isEqualToString:@"Choose a Category"])
        [self showAlertBoxWithTitle:@"Category" Message:@"Please Pick a Category"];
    else if ([[_tf_Price.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        [self showAlertBoxWithTitle:@"Field Empty" Message:@"Please Enter Price"];
    else if (![_postListingModal isNumber:[_tf_Price.text stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceCharacterSet]]])
        [self showAlertBoxWithTitle:@"Enter Price" Message:@"Price has to be a Number"];
    else if ([[_tf_Price.text stringByTrimmingCharactersInSet:
               [NSCharacterSet whitespaceCharacterSet]] integerValue] == 0)
        [self showAlertBoxWithTitle:@"" Message:@"Price cannot be Zero"];
    else if (!_startDate)
        [self showAlertBoxWithTitle:@"Start Date" Message:@"Please pick a Start date"];
    else if (!_endDate)
        [self showAlertBoxWithTitle:@"End Date" Message:@"Please pick a End date"];
    else if ([_startDate compare:_endDate] == NSOrderedDescending)
        [self showAlertBoxWithTitle:@"Correct Date" Message:@"Please pick a Start Date Earlier than End Date"];
    else if ([_startDate compare:_endDate] == NSOrderedSame)
        [self showAlertBoxWithTitle:@"Correct Date" Message:@"Start Date and End Date cannot be Same"];
    else{
        
        [self callingPostListingApi];
    }
}

#pragma mark - show Action Sheet

-(void)showActionSheetWithTitle:(NSString *) Title buttonTitleArray:(NSMutableArray *)buttonTitles andTag:(NSInteger)tag{
    
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:Title
                                  delegate:nil
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    [actionSheet setTag:tag];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    if (tag == 1) {
        
        for (NSMutableDictionary * dict in buttonTitles) {
            
            [actionSheet addButtonWithTitle:[dict valueForKey:@"category_name"]];
        }
    }
    else{
        
        for (NSString * title in buttonTitles) {
            
            [actionSheet addButtonWithTitle:title];
        }
    }
    
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

#pragma mark - Show Alert Box
-(void)showAlertBoxWithTitle:(NSString *)title Message:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Keyboard Notifications

-(void)registerKeyboardNotifications{
    
    /// register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)unregisterKeyboardNotifications{
    
    /// unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Keyboard Notification Selectors

- (void)keyboardWillShow:(NSNotification *)notification{
    
    NSDictionary* info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //    kbHeight = kbSize.height;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollViewListingContent.contentInset = contentInsets;
    self.scrollViewListingContent.scrollIndicatorInsets = contentInsets;
    
    /// If active text field is hidden by keyboard, scroll it so it's visible
    /// Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if ([currentField isKindOfClass:[UITextField class]]) {
        
        UITextField * tfTemp = (UITextField *) currentField;
        if (!CGRectContainsPoint(aRect, tfTemp.frame.origin) ) {
            
            [self.scrollViewListingContent scrollRectToVisible:tfTemp.frame animated:YES];
        }
    }
    else if ([currentField isKindOfClass:[UITextView class]]){
        
        UITextView * tVTemp = (UITextView *) currentField;
        if (!CGRectContainsPoint(aRect, tVTemp.frame.origin) ) {
            
            [self.scrollViewListingContent scrollRectToVisible:tVTemp.frame animated:YES];
        }
    }
    
}
- (void)keyboardWillHide:(NSNotification *)notification{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollViewListingContent.contentInset = contentInsets;
    self.scrollViewListingContent.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Text View Placeholder Method

-(void) addTextViewPlaceholder:(UITextView *) tView withPlaceholder:(NSString *) placeholder{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9,8,tView.bounds.size.width - 16,0)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:75.0/255.0 green:80.0/255.0 blue:83.0/255.0 alpha:1.0];
    label.text = placeholder;
    label.alpha = 1;
    label.tag = 999;
    [tView addSubview:label];
    [label sizeToFit];
    if(![tView.text isEqualToString:@""])
        [label setAlpha:0];
}

#pragma mark - API Calls

-(void)callingPostListingApi{
    
    if (![self internetWorking]) {
        
        [self showAlertBoxWithTitle:@"Internet" Message:@"Please check your internet connection"];
        return;
    }
    [_viewLoading setHidden:NO];
    [_spinner startAnimating];
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:[_dictUserInfo valueForKey:@"university_id"] forKey:@"university_id"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] forKey:@"token"];
    [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[_arrListingImages count]] forKey:@"image_count"];
    [dict setObject:_textView_Description.text forKey:@"description"];
    [dict setObject:_tf_ListingName.text forKey:@"title"];
    [dict setObject:_tf_Price.text forKey:@"price"];
    [dict setObject:_labelCurrency.text forKey:@"currency"];
    [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)_categoryId] forKey:@"category_id"];
    
    NSDateFormatter * formatterForApi = [[NSDateFormatter alloc] init];
    [formatterForApi setDateFormat:@"YYYY-MM-dd"];
    [dict setObject:[formatterForApi stringFromDate:_startDate] forKey:@"start_date"];
    [dict setObject:[formatterForApi stringFromDate:_startDate] forKey:@"end_date"];
    
    [_postListingModal callingPostAListingApi:dict :_arrListingImages :^(NSDictionary *response_success) {
        
        NSLog(@"%@",response_success);
        if (1 == [[response_success valueForKey:@"success"] integerValue]) {
            
            [_viewLoading setHidden:YES];
            [_spinner stopAnimating];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if([[response_success valueForKey:@"success"] integerValue] ==2){
            
            [_spinner stopAnimating];
            [_viewLoading removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_Token];
            [self showAlertBoxWithTitle:@"Session Expired" Message:@"Please Login to continue."];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            
            [_viewLoading setHidden:YES];
            [_spinner stopAnimating];
            [self showAlertBoxWithTitle:@"" Message:[response_success valueForKey:@"msg"]];
        }
    } :^(NSError *response_error) {
        
        [_viewLoading setHidden:YES];
        [_spinner stopAnimating];
        NSLog(@"%@",response_error);
    }];
}

-(void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
