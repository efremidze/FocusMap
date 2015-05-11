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

- (void)averageHeartRateWithCompletion:(void (^)(double averageHeartRate, NSError *error))completion;
{
    [[MVHealthKit sharedInstance] fetchAverageHeartRateWithStartDate:self.arrivalDate endDate:self.departureDate completion:^(double averageHeartRate, NSError *error) {
        if (completion)
            completion(averageHeartRate, error);
    }];
}

@end
