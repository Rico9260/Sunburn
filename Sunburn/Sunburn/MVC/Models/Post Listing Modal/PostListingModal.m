//
//  PostListingModal.m
//  Sunburn
//
//  Created by binit on 18/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "PostListingModal.h"

@implementation PostListingModal

-(void)callingPostAListingApi :(NSDictionary *) parameters :(NSMutableArray *) arrImages : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    [iOSRequest postMutlipleImages:[NSString stringWithFormat:urlPostListing,urlBase] :parameters :arrImages :^(NSDictionary *response_success) {
        
        success(response_success);
    } :^(NSError *response_error) {
        
        failure(response_error);
    }];
}

-(BOOL)isNumber:(NSString *)price {
    
        BOOL isValid = NO;
        NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:price];
        isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
        return isValid;
}

@end

