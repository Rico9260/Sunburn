//
//  CategoryModal.h
//  Sunburn
//
//  Created by binit on 11/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSRequest.h"
#import "urlContent.h"

@interface CategoryModal : NSObject

@property NSString * strCategoryName;
@property NSString * strCategoryId;

-(void)callingGetCategories:(NSString *)token : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
+ (NSArray*)parseCategoryFeedToArray:(NSArray*)array;
@end
