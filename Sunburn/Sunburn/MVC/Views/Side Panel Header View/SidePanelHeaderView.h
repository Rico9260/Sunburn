//
//  SidePanelHeaderView.h
//  Foodi
//
//  Created by Rajat Sharma on 13/05/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SunburnUser.h"
#import "ProfileViewController.h"

@protocol SidePanelHeaderDelegate

-(void)setDelegates;
-(void)btnPostListing;
-(void)btnMyProfile;

@end

@interface SidePanelHeaderView : UIView <UITextFieldDelegate>

@property (nonatomic,assign) id <SidePanelHeaderDelegate> delegate;

@property (strong , nonatomic) NSMutableDictionary * dictUserInfo;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewUser;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ConstraintTopImageView;
@property (strong, nonatomic) IBOutlet UIButton *btnUserProfile;

- (void)setupHeaderView :(NSMutableDictionary *)dictUserInfo;

- (IBAction)actionBtnPostListing:(id)sender;
- (IBAction)actionBtnUserProfile:(id)sender;


@end
