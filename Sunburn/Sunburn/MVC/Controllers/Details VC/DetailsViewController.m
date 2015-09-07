//
//  DetailsViewController.m
//  Sunburn
//
//  Created by binit on 29/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "DetailsViewController.h"
#import <UIImageView+WebCache.h>
#import "Reachability.h"

@implementation DetailsViewController

-(void)viewDidLoad{

    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [self initializeUI];
    [self callingPostDetailsApi];
    if ([_postsModal.strIsLiked integerValue] == 1) {
        
        [_btnLike setSelected:YES];
    }
}

-(void)initializeUI{
    
    _btn_Message.layer.borderWidth = 2;
    _btn_Message.layer.borderColor = [UIColor whiteColor].CGColor;
    _btn_Message.layer.cornerRadius = 5;
    _imageViewPostingUser.layer.cornerRadius = 20.0;
    [_imageViewPostingUser setClipsToBounds:YES];
    [_pageControl setNumberOfPages:[_postsModal.images count]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _viewBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.5] CGColor], (id)[[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.0] CGColor], nil];
    [_viewBar.layer insertSublayer:gradient atIndex:0];
    
    [_labelCollegeName setText:_postsModal.strUniversityName];
    [_labelDescription setText:_postsModal.strDescription];
    [_labelDistance setText:[NSString stringWithFormat:@"%@ mi away",_postsModal.strDistance]];
    /**
     *  For Likes Label
     */
    if (0 == [_postsModal.strLikes integerValue]) {
        
        [_labelLikes setText:@""];
    }
    else{
        
        [_labelLikes setText:_postsModal.strLikes];
    }
    
    /**
     *  For Shares label
     */
    if (0 == [_postsModal.strShares integerValue]) {
        
        [_labelShares setText:@""];
    }
    else{
        
        [_labelShares setText:_postsModal.strShares];
    }
    
    [_labelPrice setText:[NSString stringWithFormat:@"%@ %@",_postsModal.strCurrnecy,_postsModal.strPrice]];
    [_labelTime setText:_postsModal.strTimeSince];
    [_labelProductName setText:_postsModal.strTitle];
    [_labelUserName setText:_postsModal.strUserName];
    [_imageViewPostingUser sd_setImageWithURL:[NSURL URLWithString:_postsModal.strProfilePic]];
    if([_postsModal.strIsLiked integerValue] == 1){
        
        [_btnLike setSelected:YES];
    }
}

-(void)getDetailPostInfo:(PostsModal *)postsModal{
    
    _postsModal = postsModal;
    [_collectionView reloadData];
}

#pragma mark - COLLECTION VIEW

#pragma mark - CollectionView DataSources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_postsModal.images count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailsCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailsCollectionCell" forIndexPath:indexPath];
    collectionCell.contentView.frame = [collectionCell bounds];
    [collectionCell.imageViewProduct sd_setImageWithURL:[_postsModal.images objectAtIndex:indexPath.row]];
    return collectionCell;
}


#pragma mark - CollectionView Delegates

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeMake(self.view.frame.size.width ,collectionView.frame.size.height);
}

#pragma mark - Scroll view Delegate for Pagecontrol
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = _collectionView.frame.size.width;
    float currentPage = _collectionView.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f)){
        
        _pageControl.currentPage = currentPage + 1;
    }
    else{
        _pageControl.currentPage = currentPage;
    }
//    NSLog(@"finishPage: %ld", (long)_pageControl.currentPage);
}

#pragma mark - Api calls
-(void)callingPostDetailsApi{
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet" :@"Please Check Your Internet Connection"];
        return;
    }
    NSMutableArray * arrayLocation = [NSMutableArray new];
    
    if ([[UserLocation sharedSunburnUserLocation] arrLatLong] == nil) {
        
        arrayLocation = [[NSUserDefaults standardUserDefaults] valueForKey:UD_Location];
    }
    else{
        
        arrayLocation = [[UserLocation sharedSunburnUserLocation] arrLatLong];
    }
    [_postsModal callingPostDetailApi:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :_postsModal.strPostId :arrayLocation :^(NSDictionary *response_success) {
        
        if ([[response_success valueForKey:@"success"] integerValue] == 1) {
            
            if(![[response_success valueForKeyPath:@"post_details.like_count"] integerValue] == 0)
                [_labelLikes setText:[NSString stringWithFormat:@"%@",[response_success valueForKeyPath:@"post_details.like_count"]]];
            
            if ([[response_success valueForKeyPath:@"post_details.is_liked"] integerValue] == 1) {
                
                [_btnLike setSelected:YES];
            }
            if(![[response_success valueForKeyPath:@"post_details.share_count"] integerValue] == 0)
                [_labelShares  setText:[NSString stringWithFormat:@"%@",[response_success valueForKeyPath:@"post_details.share_count"]]];
        }
        else if([[response_success valueForKey:@"success"] integerValue] ==2){
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_Token];
            [self showAlertBox:@"Session Expired" :@"Please Login to continue."];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } :^(NSError *response_error) {
        
        NSLog(@"%@",[response_error localizedDescription]);
    }];
}

#pragma mark - Button Actions
- (IBAction)actionBtn_Message:(id)sender {
    
}

- (IBAction)actionBtn_Like:(id)sender {
    
    PostsModal * postsModal = [PostsModal new];
    [postsModal callingLikePostsApi:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :_postsModal.strPostId :^(NSDictionary *response_success) {
        
        if ([[response_success valueForKey:@"success"] integerValue] == 1) {
            
            [_labelLikes setText:[response_success valueForKey:@"like_count"]];
            [_btnLike setSelected:YES];
        }
        else if([[response_success valueForKey:@"success"] integerValue] == 0){
            
            [_btnLike setSelected:YES];
        }
        else
            [_btnLike setSelected:YES];
        
    } :^(NSError *response_error) {
        
        NSLog(@"%@",response_error);
        
        [_btnLike setSelected:NO];
    }];

}


- (IBAction)actionBtn_ShareFacebook:(id)sender {
}

- (IBAction)actionBtn_Back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
