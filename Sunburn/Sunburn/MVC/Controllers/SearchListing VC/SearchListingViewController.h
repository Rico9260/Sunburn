//
//  SearchListingViewController.h
//  Sunburn
//
//  Created by binit on 03/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Import.h"
#import "PostsModal.h"
#import "loaderView.h"
#import "DetailsViewController.h"
#import "RadioButton.h"
#import "CustomSlider.h"

@interface SearchListingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

#pragma mark - Properties
@property PostsModal * postsModal;
@property loaderView * loader;
@property NSArray * arrSearchResults;
@property BOOL filtersEnabled;

#pragma Mark - IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *tableViewSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnAction_Filter;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet CustomSlider *slider;
@property (weak, nonatomic) IBOutlet RadioButton *btnHL;
@property (weak, nonatomic) IBOutlet RadioButton *btnLH;
@property (weak, nonatomic) IBOutlet RadioButton *btnNearest;
@property (weak, nonatomic) IBOutlet UILabel *labelSlider;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *view_Filter;
@property NSUInteger sortBy;
@property BOOL filterViewShowed;

- (IBAction)actionSliderChanged:(id)sender;
#pragma mark - Button Actions
- (IBAction)btnAction_Cancel:(id)sender;

- (IBAction)btnActionShowFilters:(id)sender;

#pragma  mark - Filter View Buttons
- (IBAction)actionBtnClear:(id)sender;
- (IBAction)actionBtnApply:(id)sender;

- (IBAction)actionBtnRemoveFilter:(id)sender;
- (IBAction)actionBtnSortSelection:(id)sender;
@end
