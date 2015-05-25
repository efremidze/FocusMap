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

#import "MVLocation+Extras.h"
#import "MVVisit+Extras.h"

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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K > 0", NSStringFromSelector(@selector(averageHeartRate))];
    NSArray *array = [MVLocation findAllWithPredicate:predicate];
    [array makeObjectsPerformSelector:@selector(logAsString)];
    
    [self refreshHeartRateDataWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"success %d error %@", success, error);
    }];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
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

#pragma mark -

- (void)refreshHeartRateDataWithCompletion:(void (^)(BOOL, NSError *))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", NSStringFromSelector(@selector(averageHeartRate)), -1];
        NSArray *visits = [MVVisit findAllWithPredicate:predicate inContext:localContext];
        
        for (MVVisit *visit in visits)
            visit.averageHeartRateValue = [visit fetchAverageHeartRate];
        
        NSSet *locations = [NSSet setWithArray:[visits valueForKeyPath:@"location"]];
        for (MVLocation *location in locations)
            location.averageHeartRateValue = [location fetchAverageHeartRate];
        
        [visits makeObjectsPerformSelector:@selector(logAsString)];
        [locations makeObjectsPerformSelector:@selector(logAsString)];
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (completion)
            completion(contextDidSave, error);
    }];
}

#pragma mark -

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self refreshHeartRateDataWithCompletion:^(BOOL success, NSError *error) {
        if (error)
            completionHandler(UIBackgroundFetchResultFailed);
        else if (success)
            completionHandler(UIBackgroundFetchResultNewData);
        else
            completionHandler(UIBackgroundFetchResultNoData);
    }];
}

#pragma mark -

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
    NSArray *locations = [[MVDataManager sharedInstance] locations];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image == nil"];
    locations = [locations filteredArrayUsingPredicate:predicate];
    for (MVLocation *location in locations) {
        location.image = [location fetchImage];
    }
    
    [self refreshHeartRateDataWithCompletion:^(BOOL success, NSError *error) {
        reply(nil);
    }];
}

@end
