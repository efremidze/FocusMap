//
//  MVLocation+Extras.m
//  FocusMap
//
//  Created by Lasha Efremidze on 4/6/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MVLocation+Extras.h"
#import "MVHealthKit.h"

@implementation MVLocation (Extras)

- (void)averageHeartRateWithCompletion:(void (^)(NSNumber *averageHeartRate))completion;
{
    dispatch_group_t resolve = dispatch_group_create();

    __block NSUInteger totalDuration = 0;
    __block NSMutableArray *heartRates = [NSMutableArray arrayWithCapacity:self.visits.count];
    for (MVVisit *visit in self.visits) {
        dispatch_group_enter(resolve);
        [[MVHealthKit sharedInstance] fetchAverageHeartRateWithStartDate:visit.arrivalDate endDate:visit.departureDate completion:^(double averageHeartRate, NSError *error) {
            if (averageHeartRate > 0) {
                NSLog(@"averageHeartRate %f", averageHeartRate);
                NSUInteger duration = [visit duration];
                NSLog(@"duration %lu", (unsigned long)duration);
                totalDuration += duration;
                [heartRates addObject:@(averageHeartRate * duration)];
            }
            dispatch_group_leave(resolve);
        }];
    }
    
    dispatch_group_notify(resolve, dispatch_get_main_queue(), ^{
        NSNumber *total = [heartRates valueForKeyPath:@"@sum.doubleValue"];
        NSLog(@"totalDuration %lu", (unsigned long)totalDuration);
        NSLog(@"total %@", total);
        double average = (total.doubleValue/(float)totalDuration);
        if (completion)
            completion(@(average));
    });
}

@end
