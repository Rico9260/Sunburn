
//
//  HomePosterViewController.m
//  Sunburn
//
//  Created by binit on 05/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "HomePosterViewController.h"
#import <UIImageView+WebCache.h>
#import "UserLocation.h"
#import "Reachability.h"

@implementation HomePosterViewController

#pragma mark - View Hierarchy

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self initializeUI];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!_postsModal)
        _postsModal = [PostsModal new];
    
    [self callingPostsWRTCategory];
    [_tableViewCategories reloadData];
    [self registeNotifications];
    
    [self setLabelForViewsSwitches:[[SunburnUser sharedSunburnUserInfo] dictPostsWRTCategory]];
    
    if (_firstTimeAppRun) {
        
        [self setLabelForViewsSwitches:[[SunburnUser sharedSunburnUserInfo] dictPostsWRTCategory]];
        _loader = [[loaderView alloc] initWithFrame:[[[[UIApplication sharedApplication] delegate] window] bounds]];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:_loader];
        [_loader startAnimating];
    }
    else{
        
        [_tableViewCategories scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        Home_Poster_ViewCell * cell = [[_tableViewCategories visibleCells] lastObject];
        [cell.collectionViewPoster scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Selector

-(void)recieveIndex:(NSNotification *)notification{
    
    NSIndexPath * indexpath = (NSIndexPath *) [notification.userInfo valueForKey:@"indexPath"];
    
    if(!_filter){
        if (indexpath.row == 0) {
            
            _stringCategoryName = @"All Categories";
            [_dictNotification setObject:_stringCategoryName forKey:@"Name"];
            _stringNoOfContents = [NSString stringWithFormat:@"%lu",(unsigned long)[[[[SunburnUser sharedSunburnUserInfo] dictPostsWRTCategory] valueForKey:@"all_posts"] count]];
            [_dictNotification setObject:_stringNoOfContents  forKey:@"Contents"];
            [self postLabelNotification:_dictNotification];
        }
        else{
            
            _stringCategoryName = [[_arrCategories objectAtIndex:indexpath.row - 1] valueForKey:@"category_name"];
            [_dictNotification setObject:_stringCategoryName forKey:@"Name"];
            _stringNoOfContents = [NSString stringWithFormat:@"%lu",(unsigned long)[[[[SunburnUser sharedSunburnUserInfo] dictPostsWRTCategory] valueForKey:_stringCategoryName] count]];
            [_dictNotification setObject:_stringNoOfContents  forKey:@"Contents"];
            [self postLabelNotification:_dictNotification];
        }
        
        [_tableViewCategories scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

-(void)recieveFilterDict:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:N_AddFilter]) {
        
        _arrFilterPosts = [PostsModal parseCategoryFeedToArray:[notification.userInfo valueForKey:@"all_posts"]];
        _filter = YES;
        [_tableViewCategories reloadData];
    }
    else if ([notification.name isEqualToString:N_RemoveFilter]){
        
        _filter = NO;
        [_tableViewCategories reloadData];
    }
}
#pragma mark - Initialize UI

-(void)initializeUI{
    
    _sunburnUser = [SunburnUser sharedSunburnUserInfo];
    _arrCategoryPosts = [NSMutableArray new];
    _arrCategories = [[NSUserDefaults standardUserDefaults] valueForKey:UD_Categories];
    _filter = NO;
    _firstTimeAppRun = YES;
}


#pragma mark - API calls

-(void)callingPostsWRTCategory{
    
    if (![self internetWorking]) {
        
        [self showAlertBox:@"Internet" :@"Please Check your Internet connection"];
        [_loader stopAnimating];
        [_loader removeFromSuperview];
        return;
    }
    NSMutableArray * arrayLocation = [NSMutableArray new];
    
    if ([[UserLocation sharedSunburnUserLocation] arrLatLong] == nil) {
        
        arrayLocation = [[[NSUserDefaults standardUserDefaults] valueForKey:UD_Location] mutableCopy];
    }
    else{
        
        arrayLocation = [[[UserLocation sharedSunburnUserLocation] arrLatLong] mutableCopy];
    }
    [_postsModal callingAllPostsWRTCategory:[[NSUserDefaults standardUserDefaults] valueForKey:UD_Token] :arrayLocation :^(NSDictionary *response_success) {
        
        if (1 == [[response_success valueForKey:@"success"] integerValue]) {
            
            _dictPostsWRTCategory = [response_success mutableCopy];
            [[SunburnUser sharedSunburnUserInfo] setDictPostsWRTCategory:[response_success mutableCopy]];
            [_tableViewCategories reloadData];
            [_loader stopAnimating];
            [_loader removeFromSuperview];
            _firstTimeAppRun = NO;
            dispatch_once(&onceToken,^{
                [self setLabelForViewsSwitches:response_success];
            });
        }
        else if([[response_success valueForKey:@"success"] integerValue] == 2){
            
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
        [_tableViewCategories setUserInteractionEnabled:YES];
    }];
}

-(void)setLabelForViewsSwitches:(NSDictionary *)response_success{
    
    _stringCategoryNo = [NSString stringWithFormat:@"1"];
    _stringCategoryName = @"All Categories";
    _stringNoOfContents = [NSString stringWithFormat:@"%lu",(unsigned long)[[response_success valueForKey:@"all_posts"] count]];
    _dictNotification = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_stringCategoryName,@"Name",_stringCategoryNo,@"No",_stringNoOfContents,@"Contents", nil];
    [self postLabelNotification:_dictNotification];
}
#pragma mark - TABLE VIEW

#pragma mark - Table View Data Sources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_filter)
        return 1;
    
    return [_arrCategories count] + 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Home_Poster_ViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"Home_Poster_ViewCell"];
    
    if (indexPath.row != 0) {
        
        _arrCategoryPosts = [PostsModal parseCategoryFeedToArray:[_dictPostsWRTCategory valueForKey:[[_arrCategories objectAtIndex:indexPath.row - 1] valueForKey:@"category_name"]]];
        
        if ([_arrCategoryPosts count] == 0) {
            
            [tableCell.labelPlaceholder setHidden:NO];
        }
        else{
            
            [tableCell.labelPlaceholder setHidden:YES];
        }
        [tableCell.collectionViewPoster reloadData];
    }
    else{
        
        if (!_filter)
            _arrCategoryPosts = [PostsModal parseCategoryFeedToArray:[_dictPostsWRTCategory valueForKey:@"all_posts"]];
        else
            _arrCategoryPosts = _arrFilterPosts;
        
        if ([_arrCategoryPosts count] == 0) {
            
            [tableCell.labelPlaceholder setHidden:NO];
        }
        else{
            
            [tableCell.labelPlaceholder setHidden:YES];
        }
        _stringNoOfContents = [NSString stringWithFormat:@"%lu",(unsigned long)[_arrCategoryPosts count]];
    }
    [tableCell.collectionViewPoster reloadData];
    return tableCell;
}
#pragma  mark - TableView Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.frame.size.height;
}

#pragma mark - COLLECTION VIEW

#pragma mark - CollectionView DataSources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_arrCategoryPosts count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    _postsModal = (PostsModal *)[_arrCategoryPosts objectAtIndex:indexPath.row];
    
    /**
     *  To Change the labels in Home Poster
     */
    Home_PosterCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Home_PosterCollectionCell" forIndexPath:indexPath];
    
    [collectionCell.labelPostingUser setText:[NSString stringWithFormat:@"By %@",_postsModal.strUserName]];
    
    [collectionCell.labelProductName setText:_postsModal.strTitle];
    
    [collectionCell.labelDistance setText:[NSString stringWithFormat:@"%@ mi away",_postsModal.strDistance]];
    
    [collectionCell.labelPrice setText:[NSString stringWithFormat:@"%@%@",_postsModal.strCurrnecy,_postsModal.strPrice]];
    
    [collectionCell.labelTime setText:_postsModal.strTimeSince];
    
    [collectionCell.labelUniversityName setText:_postsModal.strUniversityName];
    
    [collectionCell.imageView_Product sd_setImageWithURL:[NSURL URLWithString:[_postsModal.images lastObject]]];
    
    if ([_postsModal.strIsLiked integerValue] == 1) {
        
        [collectionCell.btnLike setSelected:YES];
    }
    else{
        
        [collectionCell.btnLike setSelected:NO];
    }
    
    /**
     *  For Likes Label
     */
    if (0 == [_postsModal.strLikes integerValue]) {
        
        [collectionCell.labelLikes setText:@""];
    }
    else{
        
        [collectionCell.labelLikes setText:_postsModal.strLikes];
        collectionCell.strLikes = _postsModal.strLikes;
    }
    
    /**
     *  For Shares label
     */
    if (0 == [_postsModal.strShares integerValue]) {
        
        [collectionCell.labelShares setText:@""];
    }
    else{
        
        [collectionCell.labelShares setText:_postsModal.strShares];
    }
    collectionCell.postId = _postsModal.strPostId;
    [collectionCell.btnLike setTag:[_postsModal.strLikes integerValue]];
    return collectionCell;
}


#pragma mark - CollectionView Delegates

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.frame.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailsViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    if ([_arrCategoryPosts count] != 0) {
        
        _postsModal = [_arrCategoryPosts objectAtIndex:indexPath.row];
    }
    
    [VC getDetailPostInfo:_postsModal];
    [self presentViewController:VC animated:YES completion:nil];
}


#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView * collectionview = (UICollectionView *)scrollView;
        CGRect visibleRect = (CGRect){.origin = collectionview.contentOffset, .size = collectionview.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        NSIndexPath *visibleIndexPath = [collectionview indexPathForItemAtPoint:visiblePoint];
        
        if ([_arrCategoryPosts count] == 0) {
            
            _stringCategoryNo = @"0";
        }else{
            
            _stringCategoryNo = [NSString stringWithFormat:@"%ld",(long)visibleIndexPath.item + 1];
        }
        [_dictNotification setObject:_stringCategoryNo forKey:@"No"];
        
        [self postLabelNotification:_dictNotification];
    }
    else {
        
        UITableView * tableview = (UITableView *)scrollView;
        SunburnUser * sunburnUser = [SunburnUser sharedSunburnUserInfo];
        CGRect visibleRect = (CGRect){.origin = tableview.contentOffset, .size = tableview.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        NSIndexPath *visibleIndexPath = [tableview indexPathForRowAtPoint:visiblePoint];
        
        if (visibleIndexPath.row == 0) {
            
            _stringCategoryName = @"All Categories";
            [_dictNotification setObject:_stringCategoryName forKey:@"Name"];
            if ([[sunburnUser.dictPostsWRTCategory valueForKey:@"all_posts"] count] == 0) {
                
                _stringNoOfContents = @"0";
            }else{
                
                _stringNoOfContents = [NSString stringWithFormat:@"%lu",(unsigned long)[[sunburnUser.dictPostsWRTCategory valueForKey:@"all_posts"] count]];
            }
            
            [_dictNotification setObject:_stringNoOfContents  forKey:@"Contents"];
            [self postLabelNotification:_dictNotification];
        }
        else{
            
            _stringCategoryName = [[_arrCategories objectAtIndex:visibleIndexPath.row - 1] valueForKey:@"category_name"];
            [_dictNotification setObject:_stringCategoryName forKey:@"Name"];
            if ([[sunburnUser.dictPostsWRTCategory valueForKey:_stringCategoryName] count] == 0) {
                
                _stringNoOfContents = @"0";
            }else{
                
                _stringNoOfContents = [NSString stringWithFormat:@"%lu",(unsigned long)[[sunburnUser.dictPostsWRTCategory valueForKey:_stringCategoryName] count]];
            }
            [_dictNotification setObject:_stringNoOfContents  forKey:@"Contents"];
            [self postLabelNotification:_dictNotification];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView * collectionview = (UICollectionView *)scrollView;
        CGRect visibleRect = (CGRect){.origin = collectionview.contentOffset, .size = collectionview.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        NSIndexPath *visibleIndexPath = [collectionview indexPathForItemAtPoint:visiblePoint];
        if ([_arrCategoryPosts count] == 0) {
            
            _stringCategoryNo = @"0";
        }else{
            
            _stringCategoryNo = [NSString stringWithFormat:@"%ld",(long)visibleIndexPath.item + 1];
        }
        
        [_dictNotification setObject:_stringCategoryNo forKey:@"No"];
        [self postLabelNotification:_dictNotification];
    }
    else{
        
        UITableView * tableview = (UITableView *)scrollView;
        SunburnUser * sunburnUser = [SunburnUser sharedSunburnUserInfo];
        CGRect visibleRect = (CGRect){.origin = tableview.contentOffset, .size = tableview.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        NSIndexPath *visibleIndexPath = [tableview indexPathForRowAtPoint:visiblePoint];
        
        
        if (visibleIndexPath.row == 0) {
            
            _stringCategoryName = @"All Categories";
            [_dictNotification setObject:_stringCategoryName forKey:@"Name"];
            
            if ([[sunburnUser.dictPostsWRTCategory valueForKey:@"all_posts"] count] == 0) {
                
                _stringNoOfContents = @"0";
                
            }else{
                
                _stringNoOfContents = [NSString stringWithFormat:@"%lu",(unsigned long)[[sunburnUser.dictPostsWRTCategory valueForKey:@"all_posts"] count]];
            }
            [_dictNotification setObject:_stringNoOfContents  forKey:@"Contents"];
            [self postLabelNotification:_dictNotification];
        }
        else{
            
            _stringCategoryName = [[_arrCategories objectAtIndex:visibleIndexPath.row - 1] valueForKey:@"category_name"];
            [_dictNotification setObject:_stringCategoryName forKey:@"Name"];
            
            if ([[sunburnUser.dictPostsWRTCategory valueForKey:_stringCategoryName] count] == 0) {
                
                _stringNoOfContents = @"0";
                
            }else{
                
                _stringNoOfContents = [NSString stringWithFormat:@"%lu",(unsigned long)[[sunburnUser.dictPostsWRTCategory valueForKey:_stringCategoryName] count]];
            }
            [_dictNotification setObject:_stringNoOfContents  forKey:@"Contents"];
            [self postLabelNotification:_dictNotification];
        }
    }
}

/*!
 *  @author Rajat Kumar
 *
 *  @brief  Posts a Notification to change label in Home Content Controller
 *
 *  @param dictLabel It Contains strings for label Text
 */
-(void)postLabelNotification:(NSMutableDictionary *)dictLabel{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:N_LabelContent object:nil userInfo:dictLabel];
}
-(void)registeNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveIndex:) name:N_CategorySwitch object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveFilterDict:) name:N_AddFilter object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveFilterDict:) name:N_RemoveFilter object:nil];
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
