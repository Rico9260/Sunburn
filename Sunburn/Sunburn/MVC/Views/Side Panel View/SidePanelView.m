//
//  SidePanelView.m
//  Foodi
//
//  Created by Rajat Sharma on 13/05/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import "SidePanelView.h"
#import "AppDelegate.h"
#import "SidePanelTableViewCell.h"
#import <JTAlertView.h>

@implementation SidePanelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self){
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"SidePanelView" owner:self options:nil] firstObject];
        [self setFrame:frame];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self setupUI];
    [self.sidePanelTableView reloadData];
    
    return self;
}

#pragma mark - SetupUI

-(void)updateImage{
   
    [self.headerObj setupHeaderView:[[NSUserDefaults standardUserDefaults] valueForKey:UD_UserInfo]];
}

-(void)setupUI{
    
    self.sidePanelTableView.dataSource = self;
    self.sidePanelTableView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeft];
    [swipeLeft setDelegate:self];
    [tap setDelegate:self];
    
    [self addGestureRecognizer:tap];
    
    
    [self setTableHeaderAndFooters];
}


-(void)showStaticAlertWithTitle : (NSString *)title AndMessage : (NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
//    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//    [alert setCustomViewColor:[UIColor colorWithRed:58.0f/255.0f green:158.0f/255.0f blue:159.0f/255.0f alpha:1]];
//    [alert showError:self title:title subTitle:message closeButtonTitle:LocalizedString(@"OK")  duration:0.0f];
    
}


-(void)setTableHeaderAndFooters{
    
    self.headerObj = [[SidePanelHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.sidePanelTableView.frame.size.width, 200)];
    
    [self setDelegates];
    
    
    [self.headerObj setupHeaderView:[[NSUserDefaults standardUserDefaults] valueForKey:UD_UserInfo]];

    self.sidePanelTableView.tableHeaderView = self.headerObj;
    
    CGRect oldFrame = self.footerView.frame;
    
    [self.footerView setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, 70.f)];
    
    self.sidePanelTableView.tableFooterView = self.footerView;
}

-(void)handleTap : (UITapGestureRecognizer *)recognizer{
    
    [self endEditing:YES];
    
    [UIView transitionWithView: self.sidePanelTableView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    self.showUsers = NO;
    self.headerObj.frame = CGRectMake(0, 0, self.sidePanelTableView.frame.size.width, 200);
    self.headerObj.imageViewUser.hidden = NO;
    [self setDelegates];
    self.sidePanelTableView.tableHeaderView = self.headerObj;
    [self.sidePanelTableView reloadData];
    [self.delegate hideSidePanelAndAnimation:YES];
}

-(void)swipeToLeft : (UISwipeGestureRecognizer *)swipe{
    
    [self endEditing:YES];
    self.showUsers = NO;
    [self.sidePanelTableView reloadData];
    [self.delegate hideSidePanelAndAnimation:YES];
}



-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.sidePanelTableView]){
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Custom Delegate Methods

-(void)setDelegates{
    
    self.headerObj.delegate = self;
}

#pragma mark - TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    _arrCategory = [[NSUserDefaults standardUserDefaults] valueForKey:UD_Categories];
    return [_arrCategory count] + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SidePanelTableViewCell *cell = (SidePanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SidePanelTableViewCell"];
    
    if (cell == nil){
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SidePanelTableViewCell" owner:self options:nil] firstObject];
    }
    
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
   // cell.Btn_imageView.layer.cornerRadius = 0.f;
    
//    cell.Btn_imageView.tintColor = [UIColor whiteColor];
    
    if (!self.showUsers){
      
        if (indexPath.row == 0) {
            
            [cell.Label_name setText:@"All Categories"];
        }
        else{
            
            [cell.Label_name setText:[[_arrCategory objectAtIndex:indexPath.row - 1] valueForKey:@"category_name"]];
        }
        
        if(indexPath.row == _selectedIndex){
            
            cell.Label_name.textColor = [UIColor whiteColor];
        }
        else{
            
            cell.Label_name.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f  alpha:1.0f];
        }

    }
       return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    _selectedIndex = indexPath.row;
    [tableView reloadData];
    
        [self.delegate sidePanelIndexClicked:indexPath];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48.f;
}

-(void)btnMyProfile{
    
    [self.delegate btnMyProfileClicked];
}
-(void)btnPostListing{
    
    [self.delegate btnPostListingClicked];
}
@end
