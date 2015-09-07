//
//  ChatModal.h
//  Sunburn
//
//  Created by Aseem on 04/09/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModal : NSObject

-(void)callingGetChatUsers:(NSString *)token : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;

-(void)callingBlockUserApi:(NSString *)token :(NSString *)userId : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;

-(void)callingUnBlockUserApi:(NSString *)token :(NSString *)userId : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
@end
