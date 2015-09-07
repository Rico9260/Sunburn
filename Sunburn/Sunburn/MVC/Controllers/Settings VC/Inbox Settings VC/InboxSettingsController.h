//
//  InboxSettingsController.h
//  Sunburn
//
//  Created by Aseem on 04/09/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModal.h"
#import "Import.h"
#import "loaderView.h"

@interface InboxSettingsController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic) NSMutableArray * arrChatUsers;
@property ChatModal * chatModal;
@property loaderView * loader;
@property (weak, nonatomic) IBOutlet UITableView *tableViewChatUsers;

- (IBAction)actionBtnBack:(id)sender;
@end
