//
//  MOBAppDelegate.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 01/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBAppDelegate.h"

#import "App.h"

#import "MOBFormCell.h"

#import <Crashlytics/Crashlytics.h>

@implementation MOBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-50045683-1"];

    [Crashlytics startWithAPIKey:@"bd5e044767b216991ff8c3510af62e8b434d2922"];
    
    [[UIToolbar appearance] setBackgroundColor:[UIColor colorWithRed:0.88 green:0.80 blue:0.56 alpha:1.00]];
    [[UIWindow appearance] setTintColor:[UIColor colorWithRed:0.88 green:0.80 blue:0.56 alpha:1.00]];
    
    [[UILabel appearance] setTextColor:[UIColor colorWithRed:0.27 green:0.15 blue:0.08 alpha:1.00]];
    [[UITableViewCell appearance] setTintColor:[UIColor colorWithRed:0.07 green:0.71 blue:0.26 alpha:1.00]];
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithRed:0.95 green:0.96 blue:0.92 alpha:1.00]];
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.94 green:0.86 blue:0.58 alpha:1.00]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.27 green:0.15 blue:0.08 alpha:1.00]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    [[UIButton appearance] setTitleColor:[UIColor colorWithRed:0.00 green:0.71 blue:0.27 alpha:1.00] forState:UIControlStateNormal];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [App reloadTemplates];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
