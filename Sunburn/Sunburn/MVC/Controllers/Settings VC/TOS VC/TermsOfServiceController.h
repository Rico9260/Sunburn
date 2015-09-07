//
//  TermsOfServiceController.h
//  Sunburn
//
//  Created by Aseem on 02/09/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsOfServiceController : UIViewController
- (IBAction)actionBtnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webViewTOS;

@end
