//
//  HomeContentController.h
//  Sunburn
//
//  Created by binit on 05/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
#import "Import.h"
#import "CustomSlider.h"
#import "RadioButton.h"
#import "CategoryModal.h"
#import "PostsModal.h"
#import "loaderView.h"

@interface HomeContentController : UIViewController

#pragma Mark - Properties
@property NSMutableArray *arrayButtons;
@property BOOL viewsSwitched;
@property BOOL filterViewShowed;
@property NSMutableArray * arrPostInfo;
@property (strong,nonatomic) CategoryModal * categoryModal;
@property (strong ,nonatomic) PostsModal * postsModal;
@property NSUInteger sortBy;
@property loaderView * loader;

#pragma mark - IBOutlets
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet CustomSlider *slider;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) IBOutlet UIButton *btn_SwitchViews;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerView;
@property (strong, nonatomic) IBOutlet RadioButton *btnPriceHL;
@property (strong, nonatomic) IBOutlet RadioButton *btnPriceLH;
@property (strong, nonatomic) IBOutlet RadioButton *btnNewest;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *view_Filter;
@property (strong, nonatomic) IBOutlet UILabel *labelSlider;
@property (strong, nonatomic) IBOutlet UILabel *labelPageTitle;

#pragma mark - Slider Action
- (IBAction)sliderValueChanged:(id)sender;

#pragma mark - Button Actions
- (IBAction)btnAction_SideMenu:(id)sender;
- (IBAction)btnAction_SwitchViews:(id)sender;
- (IBAction)actionBtn_Filter:(id)sender;
- (IBAction)actionBtn_Search:(id)sender;
- (IBAction)actionBtn_Alert:(id)sender;
- (IBAction)actionBtn_FilterCancel:(id)sender;
- (IBAction)actionBtn_FilterClear:(id)sender;
- (IBAction)actionBtn_FilterApply:(id)sender;
- (IBAction)actionBtn_FilterSortSelection:(id)sender;

@end
