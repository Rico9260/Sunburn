//
//  urlContent.h
//  Sunburn
//
//  Created by binit on 10/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define urlBase @"http://www.code-brew.com/projects/sunburn/public/api/"

#define urlLogin @"%@user/fblogin"
#define urlEduId @"%@user/eduId"
#define urlHomePosts @"%@user/home"
#define urlLogout @"%@user/logout"
#define urlProfile @"%@user/myprofile"
#define urlUpdateProfile @"%@user/updateProfile"
#define urlUserLocation @"%@user/location"
#define urlDeleteAccount @"%@user/delete_account"

#define urlChatUsers @"%@user/user_listing"
#define urlChatUserBlock @"%@user/block_user"
#define urlChatUserUnBlck @"%@user/unblock_user"

#define urlCategories @"%@post/getCategories"
#define urlPostsWrtCategory @"%@post/postWRTCategory"
#define urlPostListing @"%@post/create"
#define urlSearchListing @"%@post/search"
#define urlFilterPosts @"%@post/filter"
#define urlSharePosts @"%@post/share"
#define urlLikePosts @"%@post/like"
#define urlPostDetails @"%@post/details"

@interface urlContent : NSObject

@end
