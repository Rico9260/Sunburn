//
//  PostListingViewController.h
//  Sunburn
//
//  Created by binit on 29/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"
#import <THDatePickerViewController.h>
#import "PostListingModal.h"
#import <JTAlertView.h>
#import <RTSpinKitView.h>

@interface PostListingViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,THDatePickerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

#pragma mark - Properties
@property (strong,nonatomic) THDatePickerViewController * datePicker;
@property (strong,nonatomic) UIImagePickerController * imagePicker;
@property (strong,nonatomic) PostListingModal * postListingModal;
@property NSMutableArray * categories;
@property NSString * selectedDate;
@property NSMutableDictionary * dictUserInfo;
@property NSMutableArray * arrCurrencies;
@property NSMutableArray * arrListingImages;
@property NSDate * startDate;
@property NSDate * endDate;
@property NSInteger categoryId;
@property RTSpinKitView * spinner;

#pragma mark - IBOutlets
@property (strong, nonatomic) IBOutlet UITextField *tf_ListingName;
@property (strong, nonatomic) IBOutlet UIView *view_postContent;
@property (strong, nonatomic) IBOutlet UITextField *tf_Price;
@property (strong, nonatomic) IBOutlet UILabel *labelCollegeName;
@property (strong, nonatomic) IBOutlet UITextView *textView_Description;
@property (strong, nonatomic) IBOutlet UILabel *labelCategoryPick;
@property (strong, nonatomic) IBOutlet UILabel *labelCurrency;
@property (strong, nonatomic) IBOutlet UIButton *btnStartDate;
@property (strong, nonatomic) IBOutlet UIButton *btnEndDate;
@property (strong, nonatomic) IBOutlet UILabel *labelEmail;
@property (strong, nonatomic) IBOutlet UILabel *labelStartDate;
@property (strong, nonatomic) IBOutlet UILabel *labelEndDate;
@property (strong, nonatomic) IBOutlet UIView *viewContent;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewListingContent;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewListingImages;
@property (strong, nonatomic) IBOutlet UIView *viewLoading;

#pragma mark - Button Actions
- (IBAction)btnAction_AddPictures:(id)sender;
- (IBAction)btnAction_ChooseCategory:(id)sender;
- (IBAction)btnAction_ChooseCurrency:(id)sender;
- (IBAction)btnAction_PickStartDate:(id)sender;
- (IBAction)btnAction_PickEndDate:(id)sender;
- (IBAction)btnAction_ClearAll:(id)sender;
- (IBAction)btnAction_Back:(id)sender;
- (IBAction)btnAction_ReviewListing:(id)sender;


@end
