//
//  AppDelegate.m
//  Frame It
//
//  Created by Mateus Nunes de B Magalhaes on 3/26/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "AppDelegate.h"
#import "AppCoordinator.h"
#import "IAPManager.h"
#import "SDStatusBarManager.h"

@interface AppDelegate ()

@property (nonatomic, retain) AppCoordinator *coordinator;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //
    // Makes navigation bar follow Apple's hidden guidelines. Always
    // comment this line out before submiting the application.
    //
    // #warning Comment out in production.
    // [[SDStatusBarManager sharedInstance] enableOverrides];
    
    // Init the in-app purchases manager.
    
    [IAPManager sharedInstance];
    
    // Init the application root coordinator.
    
    self.coordinator = [[AppCoordinator alloc] init];
    
    [self.coordinator start];
    
    // Standard window setup.
    
    self.window.frame = [[UIScreen mainScreen] bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.coordinator.rootViewController;
    
    [self.window makeKeyWindow];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive
    // state. This can occur for certain types of temporary interruptions (such
    // as an incoming phone call or SMS message) or when the user quits the
    // application and it begins the transition to the background state.
    
    // Use this method to pause ongoing tasks, disable timers, and invalidate
    // graphics rendering callbacks. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the active state; here
    // you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data
    // if appropriate. See also applicationDidEnterBackground:.
    
}

@end
