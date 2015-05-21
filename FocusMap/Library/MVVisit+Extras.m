//
//  MVVisit+Extras.m
//  FocusMap
//
//  Created by Lasha Efremidze on 5/11/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MVVisit+Extras.h"
#import "MVHealthKit.h"

@implementation MVVisit (Extras)

- (void)fetchAverageHeartRateWithCompletion:(void (^)(double, NSError *))completion;
{
    [[MVHealthKit sharedInstance] fetchAverageHeartRateWithStartDate:self.arrivalDate endDate:self.departureDate completion:^(double averageHeartRate, NSError *error) {
        if (completion)
            completion(averageHeartRate, error);
    }];
}

- (double)fetchAverageHeartRate;
{
    __block double averageHeartRate;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self fetchAverageHeartRateWithCompletion:^(double heartRate, NSError *error) {
        averageHeartRate = heartRate;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return averageHeartRate;
}

@end
