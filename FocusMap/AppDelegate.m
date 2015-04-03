//
//  AppDelegate.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "AppDelegate.h"

#import "MVLocationManager.h"
#import "MVHealthKit.h"

#import "NSManagedObject+Extras.h"
#import "CDJSONExporter.h"

@import MessageUI;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Magical Record
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:userNotificationSettings];
    
    [self.window makeKeyAndVisible];
    
    [self initHealthKit];
    [self initLocationManager];
    
    // TEMP
    [[MVVisit findAll] makeObjectsPerformSelector:@selector(logAsString)];
    
    NSLog(@"------->");
    
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(34.0157875860952, -118.4462193827858);
//    MVLocation *location = [MVLocation createLocationWithCoordinate:coordinate inContext:context];
//    [location logAsString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectContext *context = [NSManagedObjectContext MR_rootSavingContext];
        NSFetchRequest *request = [MVLocation requestAllInContext:context];
        [request setRelationshipKeyPathsForPrefetching:@[NSStringFromSelector(@selector(visits))]];
        NSArray *locations = [MVLocation executeFetchRequest:request inContext:context];
        for (MVLocation *location in locations) {
            [location logAsString];
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:location.visits.count];
            for (MVVisit *visit in location.visits) {
                [visit logAsString];
                
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                [[MVHealthKit sharedInstance] fetchAverageHeartRateWithStartDate:visit.arrivalDate endDate:visit.departureDate completionHandler:^(double averageHeartRate, NSError *error) {
                    [array addObject:@(averageHeartRate)];
                    dispatch_semaphore_signal(sema);
                }];
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            }
            NSNumber *average = [array valueForKeyPath:@"@avg.doubleValue"];
            NSLog(@"average = %@", average);
            location.averageHeartRate = average;
        }
        [context saveToPersistentStoreAndWait];
    });
    
    // start observing location changes using a sharedInstance
    // pull heart rate info from health kit
    
    // combine location and heart rate info (how?)
    // separate heart rate data into intervals, based on location changes, log location changes to know the interval of stay in the same location
    
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

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"didRegisterUserNotificationSettings %@", notificationSettings);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification %@", notification);
}

#pragma mark -

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
    
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

- (void)exportData
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_rootSavingContext];
    NSData *data = [CDJSONExporter exportContext:context auxiliaryInfo:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString %@", jsonString);
    
    MFMailComposeViewController *viewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
    [viewController addAttachmentData:data mimeType:@"application/json" fileName:@"Core Data JSON"];
    [self.window.rootViewController presentViewController:viewController animated:YES completion:nil];
}

@end
