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
    
    [self.healthStore requestAuthorizationToShareTypes:[NSSet setWithObject:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate]] readTypes:[NSSet setWithObject:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate]] completion:^(BOOL success, NSError *error) {
        if (completion) completion(success, error);
    }];
}

#pragma mark -

- (void)fetchAverageHeartRateWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(double, NSError *))completion
{
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionDiscreteAverage completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        double heartRateAverage = [result.averageQuantity doubleValueForUnit:[self heartBeatsPerMinuteUnit]];
        if (completion)
            completion(heartRateAverage, error);
    }];
    [self.healthStore executeQuery:query];
}

- (void)storeHeartRate:(double)heartRate startDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(BOOL, NSError *))completion
{
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    HKQuantity *quantity = [HKQuantity quantityWithUnit:[self heartBeatsPerMinuteUnit] doubleValue:heartRate];
    HKQuantitySample *quantitySample = [HKQuantitySample quantitySampleWithType:quantityType quantity:quantity startDate:startDate endDate:endDate];
    [self.healthStore saveObject:quantitySample withCompletion:^(BOOL success, NSError *error) {
        if (completion)
            completion(success, error);
    }];
}

#pragma mark - Helpers

- (HKUnit *)heartBeatsPerMinuteUnit
{
    return [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
}

@end
