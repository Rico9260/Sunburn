//
//  Macro.h
//  Sunburn
//
//  Created by binit on 10/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  User Defaults
 */
#define UD_Token @"SunburnAccessToken"
#define UD_UserInfo @"SunburnUserInfo"
#define UD_Categories @"Categories"
#define UD_Location @"CurrentLatLong"
#define UD_HomePosts @"HomePagePosts"



/**
 *  Notifications
 */
#define N_LabelContent @"ChangeContentLabel"
#define N_HomePosts @"HomePosts"
#define N_HomePostsGrid @"HomePostsGrid"
#define N_CategorySwitch @"CategorySwitch"
#define N_AddFilter @"AddFilter"
#define N_RemoveFilter @"RemoveFilter"
@interface Macro : NSObject

@end
