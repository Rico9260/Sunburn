/************************************************************
*                                                           *
*   file name   : iOSRequest.m                              *
*                                                           *
*   folder name : JobStar                                   *
*                                                           *
*   Created by binit on 07/05/15.                           *
*                                                           *
*   Copyright (c) 2015 Code Brew Labs. All rights reserved. *
*                                                           *
************************************************************/

#import "iOSRequest.h"
#import "AFHTTPRequestOperation.h"

@implementation iOSRequest

+(void)getJSONRespone :(NSString *)urlStr : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+(void)postMutliPartData : (NSString *)urlStr : (NSDictionary *)parameters : (NSData *)data : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
        [formData appendPartWithFileData: data name:@"profile_pic" fileName:@"temp.jpeg" mimeType:@"image/jpeg"];

     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         //              NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         failure(error);
     }];
}

+(void)postData : (NSString *)urlStr : (NSDictionary *)parameters : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {

     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         failure(error);
     }];
}

+(void)postData : (NSString *)url parameters:(NSDictionary *)dparameters  success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure

{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];

    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:dparameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

    } success:^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      NSError* error = nil;
                                      success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error]);
                                      
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      failure(error);
                                      
                                  }];
    [op start];
}

+(void)postMutlipleImages: (NSString *)urlStr : (NSDictionary *)parameters : (NSMutableArray *)imageArray : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure {
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
           int i = 0;
         for(NSData *eachImageData in imageArray){
             
             [formData appendPartWithFileData:eachImageData name:[NSString stringWithFormat:@"image%d",i ] fileName:[NSString stringWithFormat:@"image%d.jpg",i ] mimeType:@"image/jpeg"];
             
             i++;
         }
         
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         //              NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         failure(error);
     }];
}
@end
