//
//  CategoryModal.m
//  Sunburn
//
//  Created by Rajat on 11/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "CategoryModal.h"

@implementation CategoryModal


-(CategoryModal *)initWithAttributes:(NSDictionary*)attributes{

    if (self == [super self]) {
        
        _strCategoryName = [attributes valueForKey:@"category_name"];
        _strCategoryId = [attributes valueForKey:@"category_id"];
    }
    return self;
}

-(void)callingGetCategories:(NSString *)token : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    if (token == nil) {
        
        return;
    }
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:token forKey:@"token"];
    
    [iOSRequest postData:[NSString stringWithFormat:urlCategories,urlBase] parameters:dict success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

+ (NSArray*)parseCategoryFeedToArray:(NSArray*)array{
    
    NSMutableArray * arr = [NSMutableArray new];
    
    for (NSDictionary * dict in array){
        
        CategoryModal * categoryModal = [[CategoryModal alloc] initWithAttributes:dict];
        
        [arr addObject:categoryModal];
    }
    
    return arr;
}
@end
