//
//  HomeContentController.m
//  Sunburn
//
//  Created by binit on 05/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "HomeContentController.h"
#import "SidePanelView.h"
#import "UserLocation.h"
#import "Reachability.h"

@interface HomeContentController ()<SidePanelDelegate>

@property SidePanelView * viewSidePanel;
@end

@implementation HomeContentController{
    
    ContainerViewController *containerViewController;
}


#pragma mark - View Hierarchy

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self inittlaizeUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveCategoryNo:) name:N_LabelContent object:nil];
    [self callingCategoriesApi];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveCategoryNo:) name:N_LabelContent object:nil];
    [self setupSidePanel];
    [self setSidePanelDelegates];
    [self callingCategoriesApi];
    [_labelSlider setText:[NSString stringWithFormat:@"%lu mi",(unsigned long)_slider.value]];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)inittlaizeUI{
    
    _viewsSwitched = NO;
    _filterViewShowed = NO;
    [_view_Filter setHidden:YES];
    _btnPriceHL.groupButtons = @[_btnPriceHL,_btnPriceLH,_btnNewest];
    [_slider setThumbImage:[UIImage imageNamed:@"ic_dot_white"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"ic_dot_white"] forState:UIControlStateHighlighted];
    [_slider setMaximumTrackTintColor:[UIColor colorWithWhite:1 alpha:0.08f]];
    [_btnPriceHL setSelected:YES];
    _loader = [[loaderView alloc] initWithFrame:[[[[UIApplication sharedApplication] delegate] window] bounds]];
}

-(void)recieveCategoryNo:(NSNotification *)notification{
    
    NSString * categoryName = [notification.userInfo valueForKey:@"Name"];
    NSString * categoryNo;
    
    if ([[notification.userInfo valueForKey:@"No"] isEqualToString:@""] || [[notification.userInfo valueForKey:@"Contents"] integerValue] == 0) {
        
        categoryNo = [NSString stringWithFormat:@"%@ in ",[notification.userInfo valueForKey:@"Contents"]];
    }
    else{
        
        categoryNo = [NSString stringWithFormat:@"%@/%@ in ",[notification.userInfo valueForKey:@"No"],[notification.userInfo valueForKey:@"Contents"]];
    }
    NSMutableAttributedString * stringForLabel = [NSMutableAttributedString new];
    NSAttributedString * boldString = [[NSAttributedString alloc] initWithString:categoryName attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:16.0] }];
    
    [stringForLabel appendAttributedString:[[NSAttributedString alloc] initWithString:categoryNo attributes:nil]];
    [stringForLabel appendAttributedString:boldString];
    
    if ([[notification name] isEqualToString:N_LabelContent]){
        
            [_labelPageTitle setAttributedText:stringForLabel];
    }
}


#pragma mark - Setup Side Panel
-(void)setupSidePanel{
    
    self.viewSidePanel = [[SidePanelView alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
    [self.view addSubview:self.viewSidePanel];
    [self.view bringSubviewToFront:self.viewSidePanel];
    [self hideSidePanelAndAnimation:NO];
}

-(void)showSidePanel{
    
    [self.viewSidePanel setHidden:NO];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.viewSidePanel setTransform:CGAffineTransformMakeTranslation(0, 0)];
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Side panel Delegates


-(void)setSidePanelDelegates{
    
    self.viewSidePanel.delegate = self;
}

-(void)sidePanelIndexClicked:(NSIndexPath *)indexPath{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:N_CategorySwitch object:nil userInfo:@{@"indexPath":indexPath}];
    [self hideSidePanelAndAnimation:YES];
}

-(void)hideSidePanelAndAnimation : (BOOL)animate{
    
    if (!animate){
        [self.viewSidePanel setTransform:CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0)];
        [self.viewSidePanel setHidden:YES];
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.viewSidePanel setTransform:CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0)];
        
    } completion:^(BOOL finished) {
        
        [self.viewSidePanel setHidden:YES];
        [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar - 1;
    }];
}


#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        
        containerViewController = segue.destinationViewController;
    }
    //    if([segue isKindOfClass:[AnimationSegue class]]) {
    //
    //        ((AnimationSegue *)segue).originatingPoint = _btnSearch.center;
    //    }
}


#pragma  mark - Api Calls

-(void)callingCategoriesApi{
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet" :@"Please Check your internet connection"];
        return;
    }
    _categoryModal = [[CategoryModal alloc] init];
    if([_categoryModal respondsToSelector:@selector(callingGetCategories:::)])
        
        [_categoryModal callingGetCategories:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :^(NSDictionary *response_success) {
            
            if(1 == [[response_success valueForKey:@"success"] integerValue]){
                
                [[NSUserDefaults standardUserDefaults] setObject:[response_success valueForKey:@"data"] forKey:UD_Categories];
            }
            else if([[response_success valueForKey:@"success"] integerValue] ==2){
                
                [_loader stopAnimating];
                [_loader removeFromSuperview];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_Token];
                [self showAlertBox:@"Session Expired" :@"Please Login to continue"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } :^(NSError *response_error) {
            
            NSLog(@"%@",[response_error localizedDescription]);
        }];
}

-(void)callingFilterAPI{
    
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
    if(!_postsModal)
        _postsModal = [PostsModal new];
    
     [[[[UIApplication sharedApplication] delegate] window] addSubview:_loader];
    [_loader startAnimating];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",(unsigned long)_slider.value],@"distance",[NSString stringWithFormat:@"%lu",(unsigned long)_sortBy],@"sort_by", nil];
    
    [_postsModal callingFilterPostsApi:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :dict :arrayLocation :^(NSDictionary *response_success) {
        
        if ([[response_success valueForKey:@"success"] integerValue] == 1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:N_AddFilter object:nil userInfo:response_success];
            [[SunburnUser sharedSunburnUserInfo] setArrFilterPosts:[response_success valueForKey:@"all_posts"]];
            [_loader startAnimating];
            [_loader removeFromSuperview];
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
        [_loader startAnimating];
        [_loader removeFromSuperview];
    }];
}

#pragma mark - Button actions

- (IBAction)btnAction_SideMenu:(id)sender {
    
    [self showSidePanel];
}

- (IBAction)btnAction_SwitchViews:(id)sender {
    
    
    if (_viewsSwitched == NO) {
        
        [_btn_SwitchViews setImage:[UIImage imageNamed:@"ic_view_poster.png"] forState:UIControlStateNormal];
        
        _viewsSwitched = YES;
    }
    else{
        
        [_btn_SwitchViews setImage:[UIImage imageNamed:@"ic_view_grid.png"] forState:UIControlStateNormal];
        _viewsSwitched = NO;
    }
    
    [containerViewController swapViewControllers];
}

- (IBAction)actionBtn_Filter:(id)sender {
    
    //    if (NO == _filterViewShowed)
    
    [_view_Filter setHidden:NO];
    _view_Filter.frame  = CGRectMake(_view_Filter.frame.origin.x, _view_Filter.frame.origin.y, self.view.frame.size.width, 0);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        _view_Filter.frame  = CGRectMake(_view_Filter.frame.origin.x, _view_Filter.frame.origin.y, self.view.frame.size.width, 344);
    } completion:nil];
}

- (IBAction)actionBtn_Search:(id)sender {
    
    SearchListingViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchListingViewController"];
    [self presentViewController:VC animated:YES completion:nil];
}

- (IBAction)actionBtn_Alert:(id)sender {
    
    NotificationViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_Notification];
    [self presentViewController:VC animated:YES completion:nil];
}
#pragma mark - Filter Buttons
- (IBAction)actionBtn_FilterCancel:(id)sender {
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _view_Filter.frame  = CGRectMake(_view_Filter.frame.origin.x, _view_Filter.frame.origin.y, self.view.frame.size.width, 0);
    } completion:^(BOOL finished){
        
        [_view_Filter setHidden:YES];
    }];
}

- (IBAction)actionBtn_FilterClear:(id)sender {
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _view_Filter.frame  = CGRectMake(_view_Filter.frame.origin.x, _view_Filter.frame.origin.y, self.view.frame.size.width, 0);
    } completion:^(BOOL finished){
        
        [_view_Filter setHidden:YES];
    }];

    [[NSNotificationCenter defaultCenter] postNotificationName:N_RemoveFilter object:nil];
}

- (IBAction)actionBtn_FilterApply:(id)sender {
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _view_Filter.frame  = CGRectMake(_view_Filter.frame.origin.x, _view_Filter.frame.origin.y, self.view.frame.size.width, 0);
    } completion:^(BOOL finished){
        
        [_view_Filter setHidden:YES];
    }];

    [self callingFilterAPI];
}

- (IBAction)actionBtn_FilterSortSelection:(id)sender {
    
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

#pragma mark - Touches began
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - Side panel Buttons

-(void)btnPostListingClicked{
    
    [self hideSidePanelAndAnimation:YES];
    PostListingViewController * VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_PostListing];
    
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)btnMyProfileClicked{
    
    [self hideSidePanelAndAnimation:YES];
    
    ProfileViewController * VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_Profile];
    VC.showLoader = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - Slider Action
- (IBAction)sliderValueChanged:(id)sender {
    
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
