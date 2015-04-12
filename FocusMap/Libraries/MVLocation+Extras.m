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
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.visits.count];
    for (MVVisit *visit in self.visits) {
        dispatch_group_enter(resolve);
        [[MVHealthKit sharedInstance] fetchAverageHeartRateWithStartDate:visit.arrivalDate endDate:visit.departureDate completion:^(double averageHeartRate, NSError *error) {
            [array addObject:@(averageHeartRate)];
            dispatch_group_leave(resolve);
        }];
    }
    
    dispatch_group_notify(resolve, dispatch_get_main_queue(), ^{
        NSNumber *average = [array valueForKeyPath:@"@avg.doubleValue"];
        if (completion)
            completion(average);
    });
}

@end
