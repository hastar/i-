//
//  AppDelegate.m
//  i资讯
//
//  Created by lanou on 15/9/7.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "AppDelegate.h"
#import "IOSViewController.h"
#import "NewViewController.h"
#import "PictureViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    IOSViewController *IosVC = [[IOSViewController alloc] init];
    UINavigationController *IosNav = [[UINavigationController alloc] initWithRootViewController:IosVC];
    IosNav.navigationBar.translucent = NO;
    IosVC.title = @"技术";
    
    NewViewController *newVc = [[NewViewController alloc] init];
    UINavigationController *newNav = [[UINavigationController alloc] initWithRootViewController:newVc];
    newNav.navigationBar.translucent = NO;
    newVc.title = @"新闻";
    
    PictureViewController *pictureVc = [[PictureViewController alloc] init];
    UINavigationController *pictureNav = [[UINavigationController alloc] initWithRootViewController:pictureVc];
    pictureVc.title = @"福利";
    
    
    
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    [tabbar addChildViewController:pictureNav];
    [tabbar addChildViewController:newNav];
    [tabbar addChildViewController:IosNav];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    
    
    NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
