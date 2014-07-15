//
//  AKAppDelegate.m
//  Photo Browser
//
//  Created by Amog Kamsetty on 7/11/14.
//  Copyright (c) 2014 Amog Kamsetty. All rights reserved.
//

#import "AKAppDelegate.h"
#import "AKPhotosViewController.h"

#import <SimpleAuth/SimpleAuth.h>

@implementation AKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SimpleAuth.configuration[@"instagram"] = @{
            @"client_id" : @"a523b691e26640b5b60b52783be03473",
            SimpleAuthRedirectURIKey : @"photobrowser://auth/instagram"
    };
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    AKPhotosViewController *photosViewController = [[AKPhotosViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photosViewController];
    
    UINavigationBar *navigationBar = navigationController.navigationBar;
    
    navigationBar.barTintColor = [UIColor colorWithRed:242.0 / 255.0 green:122.0 / 255.0 blue:87.0 / 255.0 alpha:1.0];
    
    navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    self.window.rootViewController = navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
