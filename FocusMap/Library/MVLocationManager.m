//
//  MVLocationManager.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MVLocationManager.h"
#import "MVHealthKit.h"
#import "MVLocation+Extras.h"

NSUInteger const MVDuration = 60 * 60;

@interface MVLocationManager () <CLLocationManagerDelegate>

@end

@implementation MVLocationManager

+ (instancetype)sharedInstance;
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
    });
    return _sharedInstance;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager && [CLLocationManager locationServicesEnabled]) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
    }
    return _locationManager;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
{
    NSLog(@"didChangeAuthorizationStatus %d", status);
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startMonitoringVisits];
    } else {
        [self.locationManager stopMonitoringVisits];
    }
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit;
{
    NSLog(@"didVisit %@", visit);
    if ([visit.departureDate isEqualToDate:[NSDate distantFuture]]) {
        // User has arrived, but not left the location
    } else if ([visit.arrivalDate isEqualToDate:[NSDate distantPast]]) {
        // User has departed, but never arrived at the location
    } else if ([visit.departureDate timeIntervalSinceDate:visit.arrivalDate] < MVDuration) {
        // The visit is too short
    } else {
        // The visit is complete
        [self saveVisit:visit];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@", error);
}

#pragma mark -

- (void)saveVisit:(CLVisit *)visit
{
    NSManagedObjectContext *savingContext  = [NSManagedObjectContext MR_rootSavingContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:savingContext];
    [localContext performBlock:^{
        MVLocation *location = [MVLocation createLocationWithCoordinate:visit.coordinate inContext:localContext];
        
        MVVisit *v = [MVVisit createVisitWithArrivalDate:visit.arrivalDate departureDate:visit.departureDate inContext:localContext];
        [location addVisitsObject:v];
        
        [localContext saveToPersistentStoreAndWait];
        
        if (!location.name) {
            [location reverseGeocodeLocationWithCompletion:^(NSString *name) {
                [localContext performBlock:^{
                    location.name = name;
                    [localContext saveToPersistentStoreWithCompletion:nil];
                }];
            }];
        }
        
        [location averageHeartRateWithCompletion:^(NSNumber *averageHeartRate) {
            [localContext performBlock:^{
                location.averageHeartRate = averageHeartRate;
                [localContext saveToPersistentStoreWithCompletion:nil];
            }];
        }];
    }];
}

@end
