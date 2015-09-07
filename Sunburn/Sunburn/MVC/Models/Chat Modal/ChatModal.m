//
//  ChatModal.m
//  Sunburn
//
//  Created by Aseem on 04/09/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "ChatModal.h"
#import "iOSRequest.h"
#import "urlContent.h"

@implementation ChatModal


-(void)callingGetChatUsers:(NSString *)token : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:token forKey:@"token"];
    
    [iOSRequest postData:[NSString stringWithFormat:urlChatUsers,urlBase] parameters:dict success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

-(void)callingBlockUserApi:(NSString *)token :(NSString *)userId : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:token forKey:@"token"];
    [dict setObject:userId forKey:@"user_id2"];
    
    [iOSRequest postData:[NSString stringWithFormat:urlChatUserBlock,urlBase] parameters:dict success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

-(void)callingUnBlockUserApi:(NSString *)token :(NSString *)userId : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:token forKey:@"token"];
    [dict setObject:userId forKey:@"user_id2"];
    
    [iOSRequest postData:[NSString stringWithFormat:urlChatUserUnBlck,urlBase] parameters:dict success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}
@end
