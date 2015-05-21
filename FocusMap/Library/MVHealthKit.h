//
//  MVHealthKit.h
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import <Foundation/Foundation.h>

@import HealthKit;

@interface MVHealthKit : NSObject

@property (nonatomic, strong) HKHealthStore *healthStore;

+ (instancetype)sharedInstance;

- (void)requestAuthorizationWithCompletion:(void (^)(BOOL, NSError *))completion;

- (void)fetchAverageHeartRateWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(double, NSError *))completion;

- (void)storeHeartRate:(double)heartRate startDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(BOOL, NSError *))completion;

@end
