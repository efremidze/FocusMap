//
//  MVLocationManager.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MVLocationManager.h"

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
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
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
        // User has arrived, but not left, the location
    } else {
        // The visit is complete
        NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
        MVLocation *l = [MVLocation createLocationWithCoordinate:visit.coordinate inContext:context];
        
        MVVisit *v = [MVVisit createVisitWithArrivalDate:visit.arrivalDate departureDate:visit.departureDate inContext:context];
        [l addVisitsObject:v];
        
        [context saveToPersistentStoreAndWait];
    }
    
    UILocalNotification *notification = [UILocalNotification new];
    NSMutableString *message = [NSMutableString string];
    [message appendString:[NSString stringWithFormat:@"latitude：%f longitude：%f\n", visit.coordinate.latitude, visit.coordinate.longitude]];
    [message appendString:[NSString stringWithFormat:@"horizontalAccuracy：%f\n", visit.horizontalAccuracy]];
    [message appendString:[NSString stringWithFormat:@"arrivalDate：%@\n", visit.arrivalDate]];
    if (![visit.departureDate isEqualToDate:[NSDate distantFuture]])
        [message appendString:[NSString stringWithFormat:@"departureDate：%@\n", visit.departureDate]];
    notification.alertBody = message;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@", error);
}

@end
