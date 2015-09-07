//
//  LoginModal.m
//  Sunburn
//
//  Created by binit on 10/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "LoginModal.h"

@implementation LoginModal


-(void)callingLoginWithFaceBookApi :(NSDictionary *) parameters :(NSData *) data : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    
    [iOSRequest postMutliPartData:[NSString stringWithFormat:urlLogin,urlBase]:parameters :data  :^(NSDictionary *response_success) {
       
        success(response_success);
    } :^(NSError *response_error) {
    
        failure(response_error);
    }];
}

-(void)callingRegisterEduId :(NSDictionary *) parameters : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    [iOSRequest postData:[NSString stringWithFormat:urlEduId,urlBase] parameters:parameters success:^(NSDictionary *responseStr) {
    
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

-(void)callingLogoutApi :(NSString *) token : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:token,@"token", nil];
    
   [iOSRequest postData:[NSString stringWithFormat:urlLogout,urlBase] parameters:dict success:^(NSDictionary *responseStr) {
       
       success(responseStr);
   } failure:^(NSError *error) {
       
       failure(error);
   }];

}
-(void)callingEditProfile :(NSDictionary *) parameters :(NSData *)imageData : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    [iOSRequest postMutliPartData:[NSString stringWithFormat:urlUpdateProfile,urlBase] :parameters :imageData  :^(NSDictionary *response_success) {
        
        success(response_success);
    } :^(NSError *response_error) {
        
        failure(response_error);
    }];
}
-(void)callingUserLocationApi :(NSString *) searchkey : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{

    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:searchkey,@"searchkey", nil];
    [iOSRequest postData:@"http://www.code-brew.com/projects/sunburn/public/user/location" parameters:dict success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}
-(void)callingDeleteAccount :(NSString *) token : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{

    [iOSRequest postData:[NSString stringWithFormat:urlDeleteAccount,urlBase] parameters:[[NSDictionary alloc] initWithObjectsAndKeys:token,@"token", nil] success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString{
    
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


@end


