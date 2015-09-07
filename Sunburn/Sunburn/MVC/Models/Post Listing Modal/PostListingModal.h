//
//  PostListingModal.h
//  Sunburn
//
//  Created by binit on 18/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSRequest.h"
#import "urlContent.h"

@interface PostListingModal : NSObject

-(BOOL)isNumber:(NSString *)price;
-(void)callingPostAListingApi :(NSDictionary *) parameters :(NSMutableArray *) arrImages : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
@end
