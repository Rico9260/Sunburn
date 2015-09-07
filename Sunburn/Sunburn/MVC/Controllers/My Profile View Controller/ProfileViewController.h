//
//  ProfileViewController.h
//  Sunburn
//
//  Created by binit on 28/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"
#import "PostsModal.h"
#import "loaderView.h"
#import "LoginModal.h"

@interface ProfileViewController : UIViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property UIPageViewController * pageViewController;
@property PostsModal * postsModal;
@property loaderView * loader;
@property UIImagePickerController * imagePicker;
@property BOOL pickImage;
@property LoginModal * loginModal;
@property NSData * imageData;
@property NSString * username;
@property NSDictionary * location;
@property (weak, nonatomic) IBOutlet UITableView * tableViewLocation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableView;
@property NSMutableArray * arrLocationResults;
@property BOOL showLoader;
@property NSDictionary * dictProfilePosts;

#pragma mark - IBOutlets
@property (strong, nonatomic) IBOutlet UIView *view_Movable;
@property (weak, nonatomic) IBOutlet UIView *viewContainerProfile;
@property (strong, nonatomic) IBOutlet UIButton *btn_ActiveListings;
@property (strong, nonatomic) IBOutlet UIButton *btn_ExpiredListings;
@property (strong, nonatomic) IBOutlet UIButton *btn_Likes;
@property (strong, nonatomic) IBOutlet UIView *view_ButtonHighlight;
@property (strong, nonatomic) IBOutlet UIView *view_pages;
@property (strong, nonatomic) IBOutlet UIButton *btn_UserImage;
@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UILabel *labelUserLocation;
@property (strong, nonatomic) IBOutlet UIButton *imageViewUser;
@property (weak, nonatomic) IBOutlet UIButton *btnEditUserImage;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfLocation;
@property (weak, nonatomic) IBOutlet UIView *viewEditProfile;

#pragma mark - Button Actions
- (IBAction)btnAction_showActiveListings:(id)sender;
- (IBAction)btnAction_showExpiredListings:(id)sender;
- (IBAction)btnAction_showLikes:(id)sender;
- (IBAction)btnAction_Back:(id)sender;
- (IBAction)btnAction_Settings:(id)sender;
- (IBAction)btnAction_ShowInbox:(id)sender;
- (IBAction)btnAction_EditProfile:(id)sender;
- (IBAction)actionBtnChangePicture:(id)sender;
- (IBAction)actionBtnCancel:(id)sender;
- (IBAction)actionBtnDone:(id)sender;

#pragma mark - TextField Actions
- (IBAction)textFieldValueChanged:(id)sender;
@end
