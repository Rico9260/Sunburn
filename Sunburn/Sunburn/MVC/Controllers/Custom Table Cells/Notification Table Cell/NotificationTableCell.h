//
//  NotificationTableCell.h
//  Sunburn
//
//  Created by binit on 03/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image_User;
@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UILabel *labelNotification;
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelNotificationTime;

@end
