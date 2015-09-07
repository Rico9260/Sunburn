//
//  LoginModal.h
//  Sunburn
//
//  Created by binit on 10/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSRequest.h"
#import "urlContent.h"

@interface LoginModal : NSObject

-(void)callingLoginWithFaceBookApi :(NSDictionary *) parameters :(NSData *)data : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;

-(void)callingRegisterEduId :(NSDictionary *) parameters : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;

-(void)callingLogoutApi :(NSString *) token : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;

-(void)callingEditProfile :(NSDictionary *) parameters :(NSData *)imageData : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;

-(void)callingUserLocationApi :(NSString *) searchkey : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;

-(void)callingDeleteAccount :(NSString *) token : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;

-(BOOL) NSStringIsValidEmail:(NSString *)checkString;

@end

