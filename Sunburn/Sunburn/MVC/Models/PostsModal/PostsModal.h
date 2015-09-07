/*!
 @file PostsModal.h
 
 @brief This is the header file where my super-code is contained.
 
 This file contains the most importnant method and properties decalaration. It's parted by two methods in total, which can be used to perform temperature conversions.
 
 @author Rajat Kumar
 @copyright  2015 Rajat Kumar
 @version    15.12.7
 */

#import <Foundation/Foundation.h>
#import "iOSRequest.h"
#import "urlContent.h"

@interface PostsModal : NSObject

@property NSString * strCategoryId;
@property NSString * strCategoryName;
@property NSString * strCurrnecy;
@property NSString * strDescription;
@property NSString * strDistance;
@property NSString * strEndDate;
@property NSString * strLikes;
@property NSString * strPostId;
@property NSString * strPrice;
@property NSString * strProfilePic;
@property NSString * strShares;
@property NSString * strStartDate;
@property NSString * strTimeSince;
@property NSString * strTitle;
@property NSString * strUniversityId;
@property NSString * strUniversityName;
@property NSString * strUserId;
@property NSString * strIsLiked;
@property NSString * strUserName;
@property NSArray * images;

-(void)callingAllPosts:(NSString *)token :(NSArray *)location : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
-(void)callingAllPostsWRTCategory:(NSString *)token :(NSArray *)location : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
-(void)callingMyProfilePostsApi:(NSString *)token :(NSArray *)location : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
-(void)callingSearchPostsApi:(NSMutableDictionary *)parameters :(NSArray *)location : (void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
-(void)callingFilterPostsApi:(NSString *)token :(NSDictionary *)dictFilter :(NSArray *)location :(void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
-(void)callingLikePostsApi:(NSString *)token :(NSString *)postId :(void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
-(void)callingSharePostsApi:(NSString *)token :(NSString *)postId :(void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
-(void)callingPostDetailApi:(NSString *)token :(NSString *)postId :(NSArray *)location :(void(^)(NSDictionary * response_success))success : (void(^)(NSError * response_error))failure;
+ (NSArray*)parseCategoryFeedToArray:(NSMutableArray *)array;
@end

