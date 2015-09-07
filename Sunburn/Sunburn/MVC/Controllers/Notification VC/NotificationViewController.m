//
//  NotificationViewController.m
//  Sunburn
//
//  Created by binit on 03/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "NotificationViewController.h"

@implementation NotificationViewController

#pragma mark - View Hierarchy

-(void)viewDidLoad{
    
    [super viewDidLoad];
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 72;
}

#pragma mark TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    
    
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

       NotificationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationTableCell"];
    [cell.image_User.layer setCornerRadius:20];
    cell.image_User.clipsToBounds = YES;
        return cell;
 
}


- (IBAction)actionBtn_Back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionBtn_ClearAll:(id)sender {
}
@end
