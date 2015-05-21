//
//  MVLocationManager.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MVLocationManager.h"
#import "MVHealthKit.h"
#import "MVVisit+Extras.h"

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

- (void)saveVisit:(CLVisit *)clVisit
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        MVLocation *location = [self createLocationWithVisit:clVisit inContect:localContext];
        
        MVVisit *visit = [self createVisitWithVisit:clVisit inContect:localContext];
        [location addVisitsObject:visit];
    }];
}

- (MVLocation *)createLocationWithVisit:(CLVisit *)clVisit inContect:(NSManagedObjectContext *)context
{
    MVLocation *location = [MVLocation createLocationWithCoordinate:clVisit.coordinate inContext:context];
    if (!location.name) {
        location.name = [self nameOfLocation:location];
    }
    return location;
}

// Blocks current thread
- (NSString *)nameOfLocation:(MVLocation *)location
{
    __block NSString *name = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.latitudeValue, location.longitudeValue);
    [self reverseGeocodeLocation:coordinate withCompletion:^(CLPlacemark *placemark) {
        name = placemark.name;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return name;
}

- (void)reverseGeocodeLocation:(CLLocationCoordinate2D)coordinate withCompletion:(void (^)(CLPlacemark *placemark))completion;
{
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        if (completion)
            completion(placemark);
    }];
}

- (MVVisit *)createVisitWithVisit:(CLVisit *)clVisit inContect:(NSManagedObjectContext *)context
{
    return [MVVisit createVisitWithArrivalDate:clVisit.arrivalDate departureDate:clVisit.departureDate inContext:context];
}

@end
