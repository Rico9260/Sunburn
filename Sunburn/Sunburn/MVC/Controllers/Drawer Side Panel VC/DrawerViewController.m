//
//  DrawerViewController.m
//  Sunburn
//
//  Created by binit on 27/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "DrawerViewController.h"
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import <Accelerate/Accelerate.h>


@implementation DrawerViewController

#pragma mark - view Hierarchy
-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self initializeUI];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _arrCategories = [[NSUserDefaults standardUserDefaults] valueForKey:UD_Categories];
    [_tableView_Categories reloadData];
    
    [_imageView_UserImage sd_setImageWithURL:[NSURL URLWithString:[[_dictUserInfo valueForKey:@"profile_pic"] stringByAppendingString:@"/338/338"]]];
    [self addBlurToImageView:_imageView_UserImage.image];
}

-(void)initializeUI{
    
    _dictUserInfo = [[NSUserDefaults standardUserDefaults] valueForKey:UD_UserInfo];
    /**
     *  Profile Button Customization
     */
    _btnAction_ViewProfile.layer.cornerRadius = 32;
    _btnAction_ViewProfile.layer.borderWidth = 2;
    _btnAction_ViewProfile.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_btnAction_ViewProfile setClipsToBounds:YES];
    [_btnAction_ViewProfile sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_dictUserInfo valueForKey:@"profile_pic"] stringByAppendingString:@"/64/64"]] forState:UIControlStateNormal];
    [_btnAction_ViewProfile setContentMode:UIViewContentModeScaleAspectFill];
}

-(void)addBlurToImageView:(UIImage *)image{
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                       
                       UIImage *img =  [image applyBlurWithRadius:10 tintColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]  saturationDeltaFactor:1 maskImage:nil];
                       dispatch_sync(dispatch_get_main_queue(), ^{
                           [_imageView_UserImage setImage:img];
                       });
                   });
    
}

#pragma mark - TABLE VIEW

#pragma mark - Table View Data Sources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_arrCategories count] + 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DrawerCategoryCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"DrawerCategoryCell"];
    
    if (indexPath.row == 0) {
        
        [tableCell.label_CategoryName setText:@"All Categories"];
    }
    else{
        
        [tableCell.label_CategoryName setText:[[_arrCategories objectAtIndex:indexPath.row - 1] valueForKey:@"category_name"]];
    }
    
    
    if(indexPath.row == _selectedIndex){
        
        tableCell.label_CategoryName.textColor = [UIColor whiteColor];
    }
    else{
        
        tableCell.label_CategoryName.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f  alpha:1.0f];
    }
    return tableCell;
    
}

#pragma  mark - TableView Delegates


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedIndex = indexPath.row;
    [tableView reloadData];
}


#pragma mark - Button Actions

- (IBAction)actionBtn_PostLlisting:(id)sender {
    
    PostListingViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_PostListing];
    
    [self.frostedViewController hideMenuViewController];
    [self presentViewController:VC animated:YES completion:nil];
}
- (IBAction)btnAction_ViewProfile:(id)sender {
    
    ProfileViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:VC_Profile];
    
    [self.frostedViewController hideMenuViewController];
    [self presentViewController:VC animated:YES completion:nil];
}

@end
