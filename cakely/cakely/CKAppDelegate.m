//
//  CKAppDelegate.m
//  cakely
//
//  Created by Adam Gluck on 1/26/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "CKAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "CKServerInteraction.h"
#import "CKLoginViewController.h"

@implementation CKAppDelegate

#pragma mark - app launching methods

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // configure parse remote notifications
    [Parse setApplicationId:@"GUZMKmB4e7viLrvglj3KZDL22dwB1JYAQOVQ24fl"
                  clientKey:@"j7gWgiW0yODagwaKJaLfZYtMDaedb0x9SYkAxcBP"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    [self configureNavBar];
    [self configureRootViewController];
    return YES;
}

#pragma mark - initial configuration methods

-(void)configureRootViewController
{
    if (![[CKServerInteraction sharedServer] isLoggedIn]){
        CKLoginViewController * loginController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"loginController"];
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:loginController];
        self.window.rootViewController = navigation;
    }
}

-(void)configureNavBar
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"BG"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Light" size:17.0],
                                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSKernAttributeName : @1.0}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
                         setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                    NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Light" size:17.0f],
                                                    NSKernAttributeName: @1.0}
                                       forState:UIControlStateNormal];
}

#pragma mark - register device for remote notifications

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    // stores the phone id
    [[CKServerInteraction sharedServer] storeDeviceToken:currentInstallation.deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[CKServerInteraction sharedServer] storeDeviceToken:@""];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

#pragma mark - additional boilerplate
							
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
