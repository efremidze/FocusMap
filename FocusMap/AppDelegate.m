//
//  AppDelegate.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "AppDelegate.h"

#import "MVHealthKit.h"
#import "MVLocationManager.h"

#import "FLEXManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if DEBUG
    [[FLEXManager sharedManager] showExplorer];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:userNotificationSettings];
#endif
    
    [MVDataManager sharedInstance];
    
    [self.window makeKeyAndVisible];
    
    [self initHealthKit];
    [self initLocationManager];
    
//    NSArray *locations = [MVLocation findAll];
//    [locations makeObjectsPerformSelector:@selector(logAsString)];
//    for (MVLocation *location in locations)
//        [location.visits makeObjectsPerformSelector:@selector(logAsString)];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K > 0", NSStringFromSelector(@selector(averageHeartRate))];
    NSArray *array = [MVLocation findAllWithPredicate:predicate];
    [array makeObjectsPerformSelector:@selector(logAsString)];
    
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
    [MagicalRecord cleanUp];
}

#pragma mark -

- (void)initHealthKit
{
    [[MVHealthKit sharedInstance] requestAuthorizationWithCompletion:^(BOOL success, NSError *error) {
        if (error) {
            NSString *title = @"HealthKit";
            NSString *message = error.localizedDescription;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:action];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)initLocationManager
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
        NSString *title = @"Background Location Access Disabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL];
        }];
        [alertController addAction:settingsAction];
        
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    } else {
        [[MVLocationManager sharedInstance] locationManager];
    }
}

@end
