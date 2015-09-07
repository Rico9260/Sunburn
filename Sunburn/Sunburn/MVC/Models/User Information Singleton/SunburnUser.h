//
//  SunburnUser.h
//  Sunburn
//
//  Created by binit on 11/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunburnUser : NSObject

@property NSMutableDictionary * dictUserInfo;
@property NSArray * arrFilterPosts;
@property NSMutableDictionary * dictPostsWRTCategory;

+ (id)sharedSunburnUserInfo;
@end
