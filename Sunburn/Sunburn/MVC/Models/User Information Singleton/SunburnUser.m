//
//  SunburnUser.m
//  Sunburn
//
//  Created by binit on 11/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "SunburnUser.h"

@implementation SunburnUser

static dispatch_once_t onceToken;
static SunburnUser *sharedSunburnUser = nil;

#pragma mark - Singleton Methods


+(id)sharedSunburnUserInfo{
    
    dispatch_once(&onceToken,^{
        
        sharedSunburnUser = [[self alloc] init];
    });
    
    return sharedSunburnUser;
}

-(id)init{
    
    if (self == [super init]) {
        
        _arrFilterPosts = [NSArray new];
        _dictUserInfo = [NSMutableDictionary new];
        _dictPostsWRTCategory = [NSMutableDictionary new];
    }
    return self;
}

@end
