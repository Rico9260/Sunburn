//
//  TermsOfServiceController.m
//  Sunburn
//
//  Created by Aseem on 02/09/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "TermsOfServiceController.h"

@interface TermsOfServiceController ()

@end

@implementation TermsOfServiceController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createWebView];
}

-(void)createWebView{
    
        NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
        
        [html appendString:@"body content here"];
        [html appendString:@"</body></html>"];
        
    [_webViewTOS loadHTMLString:[html description] baseURL:nil];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)actionBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
