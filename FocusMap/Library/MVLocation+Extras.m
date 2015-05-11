//
//  MVLocation+Extras.m
//  FocusMap
//
//  Created by Lasha Efremidze on 4/6/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MVLocation+Extras.h"
#import "MVHealthKit.h"

@import CoreLocation;

@implementation MVLocation (Extras)

- (void)averageHeartRateWithCompletion:(void (^)(NSNumber *averageHeartRate))completion;
{
    [self averageHeartRateFromVisits:self.visits withCompletion:completion];
}

- (void)averageHeartRateFromVisits:(NSSet *)visits withCompletion:(void (^)(NSNumber *))completion
{
    dispatch_group_t resolve = dispatch_group_create();
    
    __block NSUInteger totalDuration = 0;
    __block NSMutableArray *heartRates = [NSMutableArray array];
    for (MVVisit *visit in visits) {
        dispatch_group_enter(resolve);
        [[MVHealthKit sharedInstance] fetchAverageHeartRateWithStartDate:visit.arrivalDate endDate:visit.departureDate completion:^(double averageHeartRate, NSError *error) {
            if (averageHeartRate > 0) {
                NSUInteger duration = [visit duration];
                totalDuration += duration;
                [heartRates addObject:@(averageHeartRate * duration)];
            }
            dispatch_group_leave(resolve);
        }];
    }
    
    dispatch_group_notify(resolve, dispatch_get_main_queue(), ^{
        NSNumber *total = [heartRates valueForKeyPath:@"@sum.doubleValue"];
        NSUInteger average = totalDuration ? (total.unsignedIntegerValue / totalDuration) : 0;
        if (completion)
            completion(@(average));
    });
}

- (void)reverseGeocodeLocationWithCompletion:(void (^)(NSString *name))completion;
{
    [self reverseGeocodeLocation:CLLocationCoordinate2DMake(self.latitudeValue, self.longitudeValue) WithCompletion:completion];
}

- (void)reverseGeocodeLocation:(CLLocationCoordinate2D)coordinate WithCompletion:(void (^)(NSString *name))completion;
{
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        if (completion)
            completion(placemark.name);
    }];
}

@end
