//
//  MVHealthKit.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MVHealthKit.h"

@interface MVHealthKit ()

@end

@implementation MVHealthKit

+ (instancetype)sharedInstance;
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
    });
    return _sharedInstance;
}

- (HKHealthStore *)healthStore
{
    if (!_healthStore && [HKHealthStore isHealthDataAvailable]) {
        _healthStore = [HKHealthStore new];
    }
    return _healthStore;
}

#pragma mark -

- (void)requestAuthorizationWithCompletion:(void (^)(BOOL success, NSError *error))completion;
{
    if (![HKHealthStore isHealthDataAvailable]) {
        if (completion) completion(NO, [NSError errorWithDomain:@"HKErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey: @"This device does not support HealthKit"}]);
        return;
    }
    
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:[NSSet setWithObject:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate]] completion:^(BOOL success, NSError *error) {
        if (completion) completion(success, error);
    }];
}

#pragma mark -

- (void)fetchAverageHeartRateWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completionHandler:(void (^)(double, NSError *))completionHandler
{
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionDiscreteAverage completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKUnit *heartBeatsPerMinuteUnit = [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
        double heartRateAverage = [result.averageQuantity doubleValueForUnit:heartBeatsPerMinuteUnit];
        if (completionHandler)
            completionHandler(heartRateAverage, error);
    }];
    [self.healthStore executeQuery:query];
}

@end
