/*!
 @file PostsModal.m
 
 @brief This is the header file where my super-code is contained.
 
 This file contains the most importnant method and properties decalaration. It's parted by two methods in total, which can be used to perform temperature conversions.
 
 @author Rajat Kumar
 @copyright  2015 Rajat Kumar
 @version    15.12.7
 */

#import "PostsModal.h"

@implementation PostsModal

-(PostsModal *)initWithAttributes:(NSDictionary *)postInfo{
    
    if (self == [super self]) {
        
        _strCategoryId = [postInfo valueForKey:@"category_id"];
        _strCategoryName = [postInfo valueForKey:@"category_name"];
        _strCurrnecy = [postInfo valueForKey:@"currency"];
        _strDescription = [postInfo valueForKey:@"description"];
        _strDistance = [postInfo valueForKey:@"distance"];
        _strEndDate = [postInfo valueForKey:@"end_date"];
        _strLikes = [postInfo valueForKey:@"like_count"];
        _strPostId = [postInfo valueForKey:@"post_id"];
        _strPrice = [postInfo valueForKey:@"price"];
        _strProfilePic = [postInfo valueForKey:@"profile_pic"];
        _strShares = [postInfo valueForKey:@"share_count"];
        _strStartDate = [postInfo valueForKey:@"start_date"];
        _strTimeSince = [postInfo valueForKey:@"time_since"];
        _strTitle = [postInfo valueForKey:@"title"];
        _strUniversityId = [postInfo valueForKey:@"university_id"];
        _strUniversityName = [postInfo valueForKey:@"university_name"];
        _strUserId = [postInfo valueForKey:@"user_id"];
        _strUserName = [postInfo valueForKey:@"username"];
        _strIsLiked = [postInfo valueForKey:@"is_liked"];
        _images = [postInfo valueForKey:@"images"];
    }
    return self;
}

-(void)callingAllPosts:(NSString *)token :(NSArray *)location : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    if (token == nil) {
        
        return;
    }
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:token forKey:@"token"];
    if (location){
        
    [dict setObject:[location objectAtIndex:0] forKey:@"current_lat"];
    [dict setObject:[location objectAtIndex:1] forKey:@"current_lng"];
    }
    
    [iOSRequest postData:[NSString stringWithFormat:urlHomePosts,urlBase] parameters:dict success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
    
}

-(void)callingAllPostsWRTCategory:(NSString *)token :(NSArray *)location : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:token forKey:@"token"];
    if (location){
        
        [dict setObject:[location objectAtIndex:0] forKey:@"current_lat"];
        [dict setObject:[location objectAtIndex:1] forKey:@"current_lng"];
    }
    
    [iOSRequest postData:[NSString stringWithFormat:urlPostsWrtCategory,urlBase] parameters:dict success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
    
}
-(void)callingMyProfilePostsApi:(NSString *)token :(NSArray *)location : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:token forKey:@"token"];
    if (location){
        
        [dict setObject:[location objectAtIndex:0] forKey:@"current_lat"];
        [dict setObject:[location objectAtIndex:1] forKey:@"current_lng"];
    }
    else{
        
        [dict setObject:@"" forKey:@"current_lat"];
        [dict setObject:@"" forKey:@"current_lng"];
    }
    
    
    [iOSRequest postData:[NSString stringWithFormat:urlProfile,urlBase] parameters:dict success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
    
}


-(void)callingSearchPostsApi:(NSMutableDictionary *)parameters :(NSArray *)location : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{

    [parameters setObject:[location objectAtIndex:0] forKey:@"current_lat"];
    [parameters setObject:[location objectAtIndex:1] forKey:@"current_lng"];
    [iOSRequest postData:[NSString stringWithFormat:urlSearchListing,urlBase] parameters:parameters success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

-(void)callingFilterPostsApi:(NSString *)token :(NSDictionary *)dictFilter :(NSArray *)location :(void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
 
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:dictFilter copyItems:YES];
    
    if (location){
        
        [dict setObject:[location objectAtIndex:0] forKey:@"current_lat"];
        [dict setObject:[location objectAtIndex:1] forKey:@"current_lng"];
    }
    
    [dict setObject:token forKey:@"token"];
    [iOSRequest postData:[NSString stringWithFormat:urlFilterPosts,urlBase] parameters:dict success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

-(void)callingLikePostsApi:(NSString *)token :(NSString *)postId :(void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{
    
    [iOSRequest postData:[NSString stringWithFormat:urlLikePosts,urlBase] parameters:[[NSDictionary alloc] initWithObjectsAndKeys:token,@"token",postId,@"post_id", nil] success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];

}
-(void)callingSharePostsApi:(NSString *)token :(NSString *)postId :(void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{

    [iOSRequest postData:[NSString stringWithFormat:urlSharePosts,urlBase] parameters:[[NSDictionary alloc] initWithObjectsAndKeys:token,@"token",postId,@"post_id", nil] success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

-(void)callingPostDetailApi:(NSString *)token :(NSString *)postId :(NSArray *)location :(void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure{

    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];

    if (location){
        
        [dict setObject:[location objectAtIndex:0] forKey:@"current_lat"];
        [dict setObject:[location objectAtIndex:1] forKey:@"current_lng"];
    }
    
    [dict setObject:token forKey:@"token"];
    [dict setObject:postId forKey:@"post_id"];
    
    [iOSRequest postData:[NSString stringWithFormat:urlPostDetails,urlBase] parameters:dict success:^(NSDictionary *responseStr) {
        
        success(responseStr);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

+ (NSArray*)parseCategoryFeedToArray:(NSMutableArray *)array{
    
    NSMutableArray * arr = [NSMutableArray new];
    
    for (NSDictionary * dict in array){
        
        PostsModal * postsModal = [[PostsModal alloc] initWithAttributes:dict];
        
        [arr addObject:postsModal];
    }
    
    return arr;
}
@end
