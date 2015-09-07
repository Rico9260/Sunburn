/************************************************************
*                                                           *
*   file name   : iOSRequest.h                              *
*                                                           *
*   folder name : JobStar                                   *
*                                                           *
*   Created by binit on 07/05/15.                           *
*                                                           *
*   Copyright (c) 2015 Code Brew Labs. All rights reserved. *
*                                                           *
************************************************************/

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface iOSRequest : NSObject

+(void)getJSONRespone :(NSString *)urlStr : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure ;

+(void)postMutliPartData : (NSString *)urlStr : (NSDictionary *)parameters : (NSData *)data : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;

+(void)postData : (NSString *)url parameters:(NSDictionary *)dparameters  success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure;

+(void)postMutlipleImages: (NSString *)urlStr : (NSDictionary *)parameters : (NSMutableArray *)imageArray : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
@end
