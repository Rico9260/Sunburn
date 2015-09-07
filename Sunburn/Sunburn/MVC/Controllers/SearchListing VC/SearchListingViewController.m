//
//  SearchListingViewController.m
//  Sunburn
//
//  Created by binit on 03/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "SearchListingViewController.h"
#import "UserLocation.h"
#import "Reachability.h"

@implementation SearchListingViewController

#pragma mark - View Hierarchy

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self initializeUI];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_tfSearch becomeFirstResponder];
}

-(void)initializeUI{
    
    _filterViewShowed = NO;
    _filtersEnabled = NO;
    [_view_Filter setHidden:YES];
    _postsModal = [PostsModal new];
    _btnHL.groupButtons = @[_btnHL,_btnLH,_btnNearest];
    [_slider setThumbImage:[UIImage imageNamed:@"ic_dot_white"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"ic_dot_white"] forState:UIControlStateHighlighted];
    [_slider setMaximumTrackTintColor:[UIColor colorWithWhite:1 alpha:0.08f]];
    [_btnHL setSelected:YES];
    _loader = [[loaderView alloc] initWithFrame:[[[[UIApplication sharedApplication] delegate] window] bounds]];
    [_labelSlider setText:[NSString stringWithFormat:@"%lu mi",(unsigned long)_slider.value]];
    _sortBy = 1;
}

#pragma mark - API calls

-(void)callingSearchApi{
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet" :@"Please Check your internet connection"];
        return;
    }
    NSMutableArray * arrayLocation = [NSMutableArray new];
    
    if ([[UserLocation sharedSunburnUserLocation] arrLatLong] == nil) {
        
        arrayLocation = [[NSUserDefaults standardUserDefaults] valueForKey:UD_Location];
    }
    else{
        
        arrayLocation = [[UserLocation sharedSunburnUserLocation] arrLatLong];
    }
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] forKey:@"token"];
    [dict setObject:_tfSearch.text forKey:@"search_key"];
    if (_filtersEnabled){
        
        [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)_sortBy] forKey:@"sort_by"];
        [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)_slider.value] forKey:@"distance"];
    }
    [_postsModal callingSearchPostsApi:dict :arrayLocation :^(NSDictionary *response_success) {
        
        if ([[response_success valueForKey:@"success"] integerValue] == 1) {
            
            _arrSearchResults = [PostsModal parseCategoryFeedToArray:[response_success valueForKey:@"all_posts"]];
            [_loader stopAnimating];
            [_loader removeFromSuperview];
            [_tableViewSearch reloadData];
        }
        else if([[response_success valueForKey:@"success"] integerValue] ==2){
            
            [_loader stopAnimating];
            [_loader removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_Token];
            [self showAlertBox:@"Session Expired" :@"Please Login to continue"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } :^(NSError *response_error) {
        
        NSLog(@"%@",response_error);
        [_loader stopAnimating];
        [_loader removeFromSuperview];
    }];
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DetailsViewController * VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_Details];
    
    [VC getDetailPostInfo:[_arrSearchResults objectAtIndex:indexPath.row]];
    [self presentViewController:VC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

#pragma mark TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    
    return [_arrSearchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableCell"];
    
    _postsModal = [_arrSearchResults objectAtIndex:indexPath.row];
    
    [cell.labelListingName setText:_postsModal.strTitle];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == [_arrSearchResults count] - 1) {
        UIView * bgView = [[UIView alloc] initWithFrame:cell.frame];
        bgView.backgroundColor =[UIColor colorWithRed:33.0f/255.0f green:43.0f/255.0f blue:56.0f/255.0f alpha:1];
        cell.backgroundView = bgView;
        cell.layer.shadowOffset = CGSizeMake(1, 0);
        cell.layer.shadowColor = [[UIColor blackColor] CGColor];
        cell.layer.shadowRadius = 5;
        cell.layer.shadowOpacity = .25;
    }
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    _loader = [[loaderView alloc] initWithFrame:[self.view frame]];
    [_loader setAlpha:0.4];
    [self.view addSubview:_loader];
    [_loader startAnimating];
    [self callingSearchApi];
    return YES;
}

#pragma mark - Button Actions
- (IBAction)btnAction_Cancel:(id)sender {
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnActionShowFilters:(id)sender {
    
    [self.view endEditing:YES];
    [_view_Filter setHidden:NO];
    _view_Filter.frame  = CGRectMake(_view_Filter.frame.origin.x, _view_Filter.frame.origin.y, self.view.frame.size.width, 0);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        _view_Filter.frame  = CGRectMake(_view_Filter.frame.origin.x, _view_Filter.frame.origin.y, self.view.frame.size.width, 344);
    } completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - Filter Buttons
- (IBAction)actionBtnClear:(id)sender {
    
    [_tfSearch becomeFirstResponder];
    _filtersEnabled = NO;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _view_Filter.frame  = CGRectMake(_view_Filter.frame.origin.x, _view_Filter.frame.origin.y, self.view.frame.size.width, 0);
    } completion:^(BOOL finished){
        
        [_view_Filter setHidden:YES];
    }];

}

- (IBAction)actionBtnApply:(id)sender {
    
    [_tfSearch becomeFirstResponder];
    _filtersEnabled = YES;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _view_Filter.frame  = CGRectMake(_view_Filter.frame.origin.x, _view_Filter.frame.origin.y, self.view.frame.size.width, 0);
    } completion:^(BOOL finished){
        
        [_view_Filter setHidden:YES];
    }];

}
- (IBAction)actionBtnRemoveFilter:(id)sender {
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _view_Filter.frame  = CGRectMake(_view_Filter.frame.origin.x, _view_Filter.frame.origin.y, self.view.frame.size.width, 0);
    } completion:^(BOOL finished){
        
        [_view_Filter setHidden:YES];
    }];
}

- (IBAction)actionBtnSortSelection:(id)sender {
    
    RadioButton * button = (RadioButton *) sender;
    
    if ([button.titleLabel.text isEqualToString:@"Price High to Low"]) {
        
        _sortBy = 1;
    }
    else if ([button.titleLabel.text isEqualToString:@"Price Low to High"]){
        
        _sortBy = 2;
    }
    else{
        
        _sortBy = 3;
    }
}
- (IBAction)actionSliderChanged:(id)sender {
    
    [_labelSlider setText:[NSString stringWithFormat:@"%lu mi",(unsigned long)_slider.value]];
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

@end
