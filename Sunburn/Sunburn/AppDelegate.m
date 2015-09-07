//
//  AppDelegate.m
//  Sunburn
//
//  Created by Rajat on 27/07/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
//    NSSetUncaughtExceptionHandler(&exceptionHandler);
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

//void exceptionHandler(NSException *exception){
//    NSLog(@"%@",[exception name]);
//    NSLog(@"%@",[exception reason]);
//    NSLog(@"%@",[exception userInfo]);
//    NSLog(@"%@",[exception callStackSymbols]);
//    NSLog(@"%@",[exception callStackReturnAddresses]);
//}
@end
