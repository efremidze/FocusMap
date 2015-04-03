//
//  MVCoreDataUtilities.m
//  FocusMap
//
//  Created by Lasha Efremidze on 4/1/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MVCoreDataUtilities.h"
#import "NSManagedObject+Extras.h"
#import "CDJSONExporter.h"
#import "MVHealthKit.h"

@implementation MVCoreDataUtilities

+ (instancetype)sharedInstance;
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
    });
    return _sharedInstance;
}

#pragma mark -

- (NSArray *)locations
{
    if (!_locations) {
        [self fetchLocationsWithCompletion:^(NSArray *locations) {
            _locations = locations;
        }];
    }
    return _locations;
}

#pragma mark -

- (void)fetchLocationsWithCompletion:(void (^)(NSArray *locations))completion;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
        NSFetchRequest *request = [MVLocation requestAllInContext:context];
        [request setRelationshipKeyPathsForPrefetching:@[NSStringFromSelector(@selector(visits))]];
        NSArray *locations = [MVLocation executeFetchRequest:request inContext:context];
        for (MVLocation *location in locations) {
            [location logAsString];
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:location.visits.count];
            for (MVVisit *visit in location.visits) {
                [visit logAsString];
                
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                [[MVHealthKit sharedInstance] fetchAverageHeartRateWithStartDate:visit.arrivalDate endDate:visit.departureDate completionHandler:^(double averageHeartRate, NSError *error) {
                    [array addObject:@(averageHeartRate)];
                    dispatch_semaphore_signal(sema);
                }];
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            }
            NSNumber *average = [array valueForKeyPath:@"@avg.doubleValue"];
            location.averageHeartRate = average;
        }
        [context saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            if (completion) completion(locations);
        }];
    });
}

#pragma mark -

+ (NSData *)JSONData;
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
    return [CDJSONExporter exportContext:context auxiliaryInfo:nil];
}

@end
